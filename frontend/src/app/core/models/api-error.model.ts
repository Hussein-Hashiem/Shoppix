export interface ApiErrorModel {
  title : string;
  status : number;
  errors : Record<string, string[]>
}
