import { Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  FormBuilder,
  ReactiveFormsModule,
  Validators
} from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { RegisterRequest } from '../../../core/models/auth.model';
import { notBlank, passwordMatchValidator, PasswordValidation } from '../../../shared/validators/auth.validator';
import { HotToastService } from '@ngxpert/hot-toast';
import { HttpErrorResponse } from '@angular/common/http';
import { getApiErrorMessages } from '../../../core/utils/error-handling.util';
import { finalize, from, Observable, of } from 'rxjs';
import { canDeactivateComponent } from '../../../core/guards/save-changes-guard';
import { ConfirmSwal } from '../../../core/utils/swal.config';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: './register.html',
  styleUrls: ['./register.css']
})
export class Register implements canDeactivateComponent{
  showConfirmPassword = signal<boolean>(false);
  showPassword = signal<boolean>(false);
  isLoading = signal<boolean>(false);
  errorMessage = signal<string>('');

  // Injections
  formBuilder = inject(FormBuilder);
  authService = inject(AuthService);
  router = inject(Router);
  toastService = inject(HotToastService);

  // Form
  registerForm = this.formBuilder.nonNullable.group(
    {
      name: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(50), notBlank]],
      email: ['', [Validators.required, Validators.email  , Validators.pattern(/^[a-zA-Z0-9._@+-]+$/)]],
      password: [
        '',
        [
          Validators.required,
          PasswordValidation
        ]
      ],
      confirmPassword: ['', [Validators.required]]
    },
    { validators: passwordMatchValidator }
  );


  togglePasswordVisibility(): void {
    this.showPassword.set(!this.showPassword());
  }

  toggleConfirmPasswordVisibility(): void {
    this.showConfirmPassword.set(!this.showConfirmPassword());
  }

  onSubmit(): void {
    if (this.registerForm.invalid) {
      if(this.registerForm.get('acceptTerms')?.errors?.['requiredTrue']){
      }
      this.registerForm.markAllAsTouched();
      return;
    }

    this.isLoading.set(true);
    this.errorMessage.set('');

    const { name, email, password } = this.registerForm.getRawValue();
    const payload: RegisterRequest = {
      name: name.trim(),
      email: email.trim(),
      password: password.trim()
    };

    this.authService.register(payload).pipe(
      finalize(()=>this.isLoading.set(false))
    ).subscribe({
      next: (response) => {
        this.registerForm.reset();
        this.toastService.success('User registered successfully');
        this.router.navigate(['/auth/login']);
      },
        error: (err: HttpErrorResponse) => {
        const { errors, status } = getApiErrorMessages(err);
        if (status === 400   || status === 422)
          this.errorMessage.set(errors.join('\n'));
        else
          this.toastService.error(errors[0]);
      }
    });
  }
    canDeactivate():Observable<boolean> {
        if(!this.registerForm.dirty)
          return of(true);
            const promise = ConfirmSwal.fire({
                  title: 'Exit',
                  text: `Your Data will be cleared.`,
                  icon: 'warning',
                  iconColor: '#e11d48',
                  confirmButtonText: 'Exit',
                  cancelButtonText: 'Cancel',
                }).then(result => result.isConfirmed);
        return from(promise);
    };
}
