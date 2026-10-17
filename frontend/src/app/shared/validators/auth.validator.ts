import { AbstractControl, ValidationErrors, ValidatorFn } from "@angular/forms";

export const PasswordValidation: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
  const value = control.value;
  if (!value) return null;

  const validators = [
    { key: 'minlength', valid: value.length >= 8 },
    { key: 'noUpperCase', valid: /[A-Z]/.test(value) },
    { key: 'noLowerCase', valid: /[a-z]/.test(value) },
    { key: 'noNumeric', valid: /[0-9]/.test(value) },
    { key: 'noSpecialChar', valid: /[!@#$%^&*(),.?":{}|<>]/.test(value) }
  ];

  const errors: ValidationErrors = validators.reduce((acc, curr) => {
    if (!curr.valid) {
      acc[curr.key] = curr.key === 'minlength'
        ? { requiredLength: 8, actualLength: value.length }
        : true;
    }
    return acc;
  }, {} as ValidationErrors);

  return Object.keys(errors).length > 0 ? errors : null;
};

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


export const notBlank: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
  const value = control.value;
  if (typeof value !== 'string' || value.length === 0) return null;
  return value.trim().length === 0 ? { blank: true } : null;
};
