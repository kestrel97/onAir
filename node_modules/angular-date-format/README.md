# angular-date-format

## Installation

To install this library, run:

```bash
$ npm install angular-date-format --save
```

## Consuming your library

Once you have published your library to npm, you can import your library in any Angular application by running:

```bash
$ npm install angular-date-format
```

and then from your Angular `AppModule`:

```typescript
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';

// Import your library
import { AngularDateFormatModule } from 'angular-date-format';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,

    // Specify your library as an import
    AngularDateFormatModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

Once your library is imported, you can use its components, directives and pipes in your Angular application:

```html
  <mat-date-format
    name="date"
    usefullDate="false"
    holiday="false"
    weekend="false"
    minDate=""
    maxDate=""
    forceMask="false"
    placeholder='Type a date'
    format="DD/MM/YYYY"
    [(ngModel)]="myModel"
  >
  </mat-date-format>
```

## License

MIT
