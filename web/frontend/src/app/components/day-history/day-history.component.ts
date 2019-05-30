import { Component, OnInit } from '@angular/core';
var dateFormat = require('dateformat');
@Component({
  selector: 'app-day-history',
  templateUrl: './day-history.component.html',
  styleUrls: ['./day-history.component.css']
})
export class DayHistoryComponent implements OnInit {

  constructor() { }

  ngOnInit() {

    let now = new Date();
    dateFormat(now, "dddd, mmmm dS, yyyy, h:MM:ss TT");
  }

}
