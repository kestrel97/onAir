import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SearchByLocComponent } from './search-by-loc.component';

describe('SearchByLocComponent', () => {
  let component: SearchByLocComponent;
  let fixture: ComponentFixture<SearchByLocComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SearchByLocComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SearchByLocComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
