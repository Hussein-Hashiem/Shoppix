import {  HttpInterceptorFn } from '@angular/common/http';
import { catchError, throwError, timeout } from 'rxjs';
import { timeoutError, offlineError } from '../utils/error-handling.util';

export const networkInterceptor: HttpInterceptorFn = (req, next) => {
  // Check if Online
  if (!navigator.onLine)
    return throwError(offlineError);

    return next(req).pipe(
    timeout(20000),
    catchError(err => {
      if (err.name === 'TimeoutError')
        return throwError(timeoutError);
      if (err.status === 0)
        return throwError(offlineError);
      return throwError(() => err);
    })
  );
};
