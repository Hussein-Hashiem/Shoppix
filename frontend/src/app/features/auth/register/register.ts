import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AbstractControl, FormBuilder, FormGroup, Validators, ReactiveFormsModule, ValidationErrors } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth';

function passwordMatchValidator(control: AbstractControl): ValidationErrors | null {
  const password = control.get('password')?.value;
  const confirmPassword = control.get('confirmPassword')?.value;

  return password === confirmPassword ? null : { passwordMismatch: true };
}

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: './register.html',
  styleUrls: ['./register.css']
})
export class Register {
  registerForm: FormGroup;
  showPassword = false;
  showConfirmPassword = false;
  isLoading = false;
  errorMessage = '';

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {
    this.registerForm = this.fb.group(
      {
        fullName: ['', [Validators.required, Validators.minLength(3)]],
        email: ['', [Validators.required, Validators.email]],
        password: ['', [Validators.required, Validators.minLength(8)]],
        confirmPassword: ['', [Validators.required]],
        acceptTerms: [false, [Validators.requiredTrue]]
      },
      { validators: passwordMatchValidator }
    );
  }

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  toggleConfirmPasswordVisibility(): void {
    this.showConfirmPassword = !this.showConfirmPassword;
  }

  onSubmit(): void {
    if (this.registerForm.invalid) {
      this.registerForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    // تجهيز البيانات المرسلة للباك إند (غالباً الباك إند لا يحتاج acceptTerms أو confirmPassword)
    const { fullName, email, password } = this.registerForm.value;
    const payload = {
      name: fullName, // تأكدي هل الباك إند مسميها name أم fullName
      email,
      password
    };

    // إرسال الـ Request للباك إند
    this.authService.register(payload as any).subscribe({
      next: (response) => {
        this.isLoading = false;
        console.log('Registration successful:', response);
        
        // لو الباك بيرجع Token ممكن تخزنيه في localStorage:
        if (response.token) {
          localStorage.setItem('token', response.token);
        }

        // تحويل المستخدم لصفحة الـ Login أو الـ Home
        this.router.navigate(['/login']);
      },
      error: (err) => {
        this.isLoading = false;
        console.error('Registration failed:', err);
        // عرض رسالة الخطأ القادمة من السيرفر
        this.errorMessage = err.error?.message || 'حدث خطأ أثناء التسجيل، يرجى المحاولة لاحقاً';
      }
    });
  }
}