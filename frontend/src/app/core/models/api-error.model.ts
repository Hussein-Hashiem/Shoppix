export interface ApiErrorModel {
  type?:"string";
  title: string;
  status: number;
  errors: Record<string, string[]>
}
export type ErrorState = 'OFFLINE' | 'SERVER' | '';
