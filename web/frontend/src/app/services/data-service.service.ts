import { Injectable } from '@angular/core';
import { Http, Headers } from '@angular/http';
import { map } from 'rxjs/operators';
// import { JwtHelperService } from '@auth0/angular-jwt';


@Injectable({
  providedIn: 'root'
})
export class DataServiceService {

  constructor(private http:Http) { }

  getnews(location){
    let headers = new Headers();
  headers.append("Content-Type", "application/json");
  return this.http.post('http://localhost:3000/users/history', location, {headers: headers})
    .pipe(map(res => res.json()))
  }
}
