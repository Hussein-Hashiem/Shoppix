
export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  name: string;
  email: string;
  password: string;
}


export interface LoginResponse {
  name: string;
  email: string;
  token: string;
  expiresIn: number;
  refreshToken: string;
  refreshTokenExpiration: string;
}

export interface RegisterResponse {
  userId: string,
  name: string,
  email: string
}
