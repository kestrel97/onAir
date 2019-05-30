import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { RouterModule, Routes} from '@angular/router';

import { FlashMessagesModule } from 'angular2-flash-messages';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { DayHistoryComponent } from './components/day-history/day-history.component';
import { SearchByLocComponent } from './components/search-by-loc/search-by-loc.component';

import {DataServiceService} from './services/data-service.service';

const appRoutes: Routes =  [
  {path:'', component: SearchByLocComponent},
  {path:'history', component: DayHistoryComponent},

]

@NgModule({
  declarations: [
    AppComponent,
    DayHistoryComponent,
    SearchByLocComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpModule,
    RouterModule.forRoot(appRoutes),
  ],
  providers: [DataServiceService],
  bootstrap: [AppComponent]
})
export class AppModule { }
