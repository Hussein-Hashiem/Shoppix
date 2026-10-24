import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { jwtDecode } from "jwt-decode";
import {  unauthorizedError } from '../utils/error-handling.util';
import { catchError, switchMap, throwError } from 'rxjs';

const unCredentialsURLS = [
  "/refresh",
  "/login",
  "/register",
  "/products"
]
function isCredentialsURL(url: string) {
  return unCredentialsURLS.some((credentialsURL) => url.includes(credentialsURL));
}
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  //Injections 
  const authService = inject(AuthService);

  if (isCredentialsURL(req.url)) {
    return next(req);
  } else {
    const { token, refreshToken, refreshTokenExpiration } = authService.getTokens();
    if (!token)
      return throwError(unauthorizedError);
    let isTokenExpired = false;
    try {
      const tokenExpirationTime = jwtDecode<{ exp: number }>(token).exp * 1000;
      isTokenExpired = tokenExpirationTime < Date.now();
    } catch (error) {
      isTokenExpired = true;
    }

    if (isTokenExpired) {
      const isRefreshTokenValid = new Date(refreshTokenExpiration).getTime() > Date.now();
      if (!isRefreshTokenValid) {
        authService.logout();
        return throwError(unauthorizedError);
      } else {
        return authService.refreshTokens({ token: token, refreshToken: refreshToken }).pipe(
          catchError((err) => {
            if (err.status === 400 || err.status === 401) {
              authService.logout();
              return throwError(() => unauthorizedError);
            }
            return throwError(() => err);
          }),
          switchMap((response) =>
            next(req.clone({
              headers: req.headers.set('Authorization', `Bearer ${response.token}`)
            }))
          )
        );
      }
    } else {
      return next(
        req.clone(
          {
            headers: req.headers.set('Authorization', `Bearer ${token}`)
          }));
    }
  }
};
