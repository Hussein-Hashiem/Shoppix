import { Component, computed, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, Validators, ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { HotToastService } from '@ngxpert/hot-toast';
import { AuthService } from '../../../core/services/auth.service';
import { PasswordValidation } from '../../../shared/validators/auth.validator';
import { LoginRequest } from '../../../core/models/auth.model';
import { HttpErrorResponse } from '@angular/common/http';
import { getApiErrorMessages } from '../../../core/utils/error-handling.util';
import { finalize, from, Observable, of } from 'rxjs';
import { canDeactivateComponent } from '../../../core/guards/save-changes-guard';
import { ConfirmSwal } from '../../../core/utils/swal.config';
import { LucideEye, LucideEyeClosed, LucideMail, LucideLock } from "@lucide/angular"
import { toSignal } from '@angular/core/rxjs-interop';
@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink, LucideEye, LucideEyeClosed, LucideMail, LucideLock],
  templateUrl: './login.html',
  styleUrls: ['./login.css']
})
export class Login implements canDeactivateComponent {
  showPassword = signal<boolean>(false);
  isLoading = signal<boolean>(false);
  errorMessage = signal<string>('');

  // Injections
  formBuilder = inject(FormBuilder);
  authService = inject(AuthService);
  router = inject(Router);
  route = inject(ActivatedRoute);
  toastService = inject(HotToastService);

  loginForm = this.formBuilder.nonNullable.group({
    email: ['', [Validators.email, Validators.required, Validators.pattern(/^[a-zA-Z0-9._@+-]+$/)]],
    password: ['', [Validators.required, PasswordValidation]],
  });
  togglePasswordVisibility(): void {
    this.showPassword.set(!this.showPassword());
  }

  private queryParams = toSignal(this.route.queryParamMap, {
    initialValue: this.route.snapshot.queryParamMap
  });
  returnUrl = computed(() => this.queryParams().get('returnUrl') ?? '/home');

  onSubmit(): void {
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    this.isLoading.set(true);
    this.errorMessage.set('');
    const { email, password } = this.loginForm.getRawValue();

    const payload: LoginRequest = {
      email: email.trim(),
      password: password.trim()
    };

    this.authService.login(payload).pipe(
      finalize(() => this.isLoading.set(false))
    ).subscribe({
      next: (response) => {
        this.authService.handleLoginSuccess(response.token, response.refreshToken, response.refreshTokenExpiration);
        this.loginForm.reset();
        this.toastService.success('User logged in successfully');
        this.router.navigate([this.returnUrl() || '/home']);
      },
      error: (err: HttpErrorResponse) => {
        const { errors, status } = getApiErrorMessages(err);
        if (status === 400 || status === 422)
          this.errorMessage.set(errors.join('\n'));
        else
          this.toastService.error(errors[0]);
      }
    })
  }
  canDeactivate(): Observable<boolean> {
    if (!this.loginForm.dirty)
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
