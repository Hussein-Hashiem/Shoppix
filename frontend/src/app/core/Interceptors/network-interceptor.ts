import { HttpInterceptorFn } from '@angular/common/http';
import { catchError, throwError, timeout } from 'rxjs';
import { ApiErrorModel } from '../models/api-error.model';

export const networkInterceptor: HttpInterceptorFn = (req, next) => {
  // Check if Online
  if (!navigator.onLine)
    return throwError((): ApiErrorModel =>
    ({
      "title": "OFFLINE",
      "status": 0,
      "errors": {
        "network.noconnection": [
          "No Internet , Please Check Your Connection"
        ]
      }
    }))
  return next(req).pipe(
    timeout(5000),
    catchError(err => {
      if (err.name === "TimeoutError") {
        return throwError((): ApiErrorModel =>
        ({
          "title": "TimeOut",
          "status": 408,
          "errors": {
            "network.timeOut": [
              "The request timed out. please try again"
            ]
          }
        }))
      }

      return throwError(()=>err);
    }))
};
