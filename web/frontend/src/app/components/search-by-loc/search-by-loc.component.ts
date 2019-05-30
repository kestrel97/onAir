import { Component, OnInit } from '@angular/core';
import { DataServiceService } from '../../services/data-service.service';
import { Router } from '@angular/router';
import { FlashMessagesService } from 'angular2-flash-messages';

@Component({
  selector: 'app-search-by-loc',
  templateUrl: './search-by-loc.component.html',
  styleUrls: ['./search-by-loc.component.css']
})
export class SearchByLocComponent implements OnInit {
  location:any


  constructor(  private dataService: DataServiceService,
      private router: Router) { }

  ngOnInit() {
  }
  onSubmit(){
      location: this.location

      this.dataService.getnews(location).subscribe(data => {
      if(data.success){
        this.flashMessageService.show('Data has been fetched', {
          cssClass: 'alert-success',
          timeout: 5000});
        this.router.navigate(['/dayHistory']);
      } else {
        this.flashMessageService.show(data.msg, {
          cssClass: 'alert-danger',
          timeout: 5000});
        this.router.navigate(['searchByLoc']);
      }
    });
  }



}
