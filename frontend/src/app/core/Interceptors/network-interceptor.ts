import { HttpErrorResponse, HttpInterceptorFn } from '@angular/common/http';
import { catchError, throwError, timeout } from 'rxjs';
import { ApiErrorModel } from '../models/api-error.model';

function networkError(
  status: number,
  title: string,
  key: string,
  message: string
): HttpErrorResponse {
  const body: ApiErrorModel = {
    title,
    status,
    errors: { [key]: [message] }
  };
  return new HttpErrorResponse({ status, error: body });
}

const offlineError = () =>
  networkError(0, 'OFFLINE', 'network.noconnection', 'No Internet, Please Check Your Connection');

const timeoutError = () =>
  networkError(408, 'TimeOut', 'network.timeOut', 'The request timed out. Please try again');

export const networkInterceptor: HttpInterceptorFn = (req, next) => {
  // Check if Online
  if (!navigator.onLine)
    return throwError(offlineError);

    return next(req).pipe(
    timeout(15000),
    catchError(err => {
      if (err.name === 'TimeoutError')
        return throwError(timeoutError);
      if (err.status === 0)
        return throwError(offlineError);
      return throwError(() => err);
    })
  );
};
