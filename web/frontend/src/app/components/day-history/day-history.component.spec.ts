import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DayHistoryComponent } from './day-history.component';

describe('DayHistoryComponent', () => {
  let component: DayHistoryComponent;
  let fixture: ComponentFixture<DayHistoryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DayHistoryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DayHistoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
