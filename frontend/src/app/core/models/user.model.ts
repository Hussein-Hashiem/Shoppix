// بيانات المستخدم الأساسية
export interface UserModel {
  id: string | number;
  name: string;
  email: string;
  role?: string;
  avatar?: string;
  createdAt?: string;
}

// البيانات المطلوبة عند تسجيل الدخول (Login)
export interface LoginRequest {
  email: string;
  password: string;
  rememberMe?: boolean;
}

// البيانات المطلوبة عند إنشاء حساب جديد (Register)
export interface RegisterRequest {
  name: string;
  email: string;
  password: string;
  confirmPassword?: string;
}

// الرد القادم من السيرفر بعد تسجيل الدخول أو إنشاء الحساب (Auth Response)
export interface AuthResponse {
  user: UserModel;
  token: string;
  refreshToken?: string;
  message?: string;
}