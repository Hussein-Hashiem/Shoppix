import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  AbstractControl,
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  ValidationErrors,
  ValidatorFn,
  Validators
} from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth';
import { RegisterRequest } from '../../../core/models/user.model';

// دالة التحقق من تطابق كلمتي المرور
export const passwordMatchValidator: ValidatorFn = (
  control: AbstractControl
): ValidationErrors | null => {
  const password = control.get('password');
  const confirmPassword = control.get('confirmPassword');

  if (password && confirmPassword && password.value !== confirmPassword.value) {
    return { passwordMismatch: true };
  }
  return null;
};

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
    private authService: AuthService, // حقن الـ Service
    private router: Router            // للتنقل بعد نجاح التسجيل
  ) {
    this.registerForm = this.fb.group(
      {
        fullName: ['', [Validators.required, Validators.minLength(3)]],
        email: ['', [Validators.required, Validators.email]],
        password: [
          '',
          [
            Validators.required,
            Validators.minLength(8),
            // يشترط حرفاً كبيراً، حرفاً صغيراً، رقماً، ورمزاً خاصاً
            Validators.pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/)          ]
        ],
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

//   // دوال مساعدة لفحص كل شرط على حدة
// get passwordValue(): string {
//   return this.registerForm.get('password')?.value || '';
// }

// get hasMinLength(): boolean {
//   return this.passwordValue.length >= 8;
// }

// get hasUpperCase(): boolean {
//   return /[A-Z]/.test(this.passwordValue);
// }

// get hasLowerCase(): boolean {
//   return /[a-z]/.test(this.passwordValue);
// }

// get hasNumber(): boolean {
//   return /\d/.test(this.passwordValue);
// }

// get hasSpecialChar(): boolean {
//   return /[\W_]/.test(this.passwordValue);
// }

  // onSubmit(): void {
  //   // 1. التحقق من صحة المدخلات في الفورم
  //   if (this.registerForm.invalid) {
  //     this.registerForm.markAllAsTouched();
  //     return;
  //   }

  //   this.isLoading = true;
  //   this.errorMessage = '';

  //   // 2. تجهيز البيانات المرسلة (Payload) لتطابق ما ينتظره الباك إند
  //   const { fullName, email, password } = this.registerForm.value;
  //   const payload: RegisterRequest = {
  //     name: fullName, // لو الباك إند مسميها name
  //     email: email,
  //     password: password
  //   };

  //   // 3. استدعاء السيرفيس وإرسال البيانات
  //   this.authService.register(payload).subscribe({
  //     next: (response) => {
  //       this.isLoading = false;
  //       console.log('User registered successfully:', response);

  //       // إذا كان الباك إند يرجع توكن عند التسجيل مباشرة:
  //       if (response.token) {
  //         localStorage.setItem('token', response.token);
  //       }

  //       // توجيه المستخدم لصفحة تسجيل الدخول (أو الصفحة الرئيسية)
  //       this.router.navigate(['/login']);
  //     },
  //     error: (err) => {
  //       this.isLoading = false;
  //       console.error('Registration failed:', err);
  //       // إظهار رسالة الخطأ القادمة من الباك إند
  //       this.errorMessage = err.error?.message || 'حدث خطأ أثناء التسجيل، يرجى المحاولة لاحقاً';
  //     }
  //   });
  // }

  onSubmit(): void {
    if (this.registerForm.invalid) {
      this.registerForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    const { fullName, email, password } = this.registerForm.value;
    const payload = {
      name: fullName,
      email: email,
      password: password
    };

    this.authService.register(payload as any).subscribe({
      next: (response) => {
        this.isLoading = false;
        console.log('User registered successfully:', response);


        this.router.navigate(['/login']);
      },
      error: (err) => {
        this.isLoading = false;
        console.error('Registration failed:', err);

        // قراءة رسائل الأخطاء القادمة من ASP.NET Problem Details
        if (err.error?.errors) {
          const errorKeys = Object.keys(err.error.errors);
          if (errorKeys.length > 0) {
            const firstKey = errorKeys[0];
            const messages = err.error.errors[firstKey];
            this.errorMessage = Array.isArray(messages) ? messages[0] : messages;
          } else {
            this.errorMessage = err.error.title || 'حدث خطأ أثناء التسجيل';
          }
        } else if (err.error?.message) {
          this.errorMessage = err.error.message;
        } else {
          this.errorMessage = 'حدث خطأ في الاتصال بالسيرفر، يرجى المحاولة لاحقاً';
        }
      }
    });
  }
}