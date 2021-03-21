import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teste_app/src/evento.dart';
import 'package:teste_app/services/databaseService.dart';

final Map<DateTime, List> _holidays = {
//   DateTime(2020, 1, 1): ['New Year\'s Day'],
//   DateTime(2020, 1, 6): ['Epiphany'],
//   DateTime(2020, 2, 14): ['Valentine\'s Day'],
//   DateTime(2020, 4, 21): ['Easter Sunday'],
//   DateTime(2020, 4, 22): ['Easter Monday'],
  DateTime(2020, 1, 1): [new Evento.feriado("Confraternização Universal")],
  DateTime(2020, 2, 24): [new Evento.feriado("Carnaval")],
  DateTime(2020, 2, 25): [new Evento.feriado("Carnaval")],
  DateTime(2020, 2, 26): [new Evento.feriado("Quarta-feira de cinzas")],
  DateTime(2020, 4, 10): [new Evento.feriado("Paixão de Cristo")],
  DateTime(2020, 4, 21): [new Evento.feriado("Tiradentes")],
  DateTime(2020, 5, 1): [new Evento.feriado("Dia Mundial do Trabalho")],
  DateTime(2020, 6, 11): [new Evento.feriado("Corpus Christi")],
  DateTime(2020, 9, 7): [new Evento.feriado("Independência do Brasil")],
  DateTime(2020, 10, 12): [new Evento.feriado("Nossa Senhora Aparecida")],
  DateTime(2020, 10, 28): [new Evento.feriado("Dia do Servidor Público")],
  DateTime(2020, 11, 2): [new Evento.feriado("Finados")],
  DateTime(2020, 12, 15): [new Evento.feriado("Proclamação da República")],
  DateTime(2020, 12, 24): [new Evento.feriado("véspera de natal")],
  DateTime(2020, 12, 25): [new Evento.feriado("Natal")],
  DateTime(2020, 12, 31): [new Evento.feriado("véspera de ano novo ")],
};

// final databaseReference = FirebaseDatabase.instance.reference();

// void getData() {
//   databaseReference.once().then((DataSnapshot snapshot) {
//     print('Data : ${snapshot.value}');
//   });
// }

class Calendario extends StatefulWidget {
  @override
  CalendarioState createState() => CalendarioState();
}

class CalendarioState extends State<Calendario> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List<Evento> tempEvents = [];
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _calendarController = CalendarController();

    DatabaseService().getEventos().then((data) {
      if (data.isEmpty) {
        print("Data empty!");
        return;
      }
      data.forEach((f) {
        if (f.exists) {
          var tempDate = DateTime.parse(f.data['date'].toDate().toString());
          var tempNome = f.data['nome'];
          var tempFeriado = f.data['feriado'];
          if (tempFeriado) {
            tempEvents.add(new Evento.feriado(tempNome, data: tempDate));
          } else {
            tempEvents.add(new Evento(tempNome, tempDate));
          }
        }
      });
      setState(() {
        tempEvents.forEach((evento) {
          if (_events[evento.dateTime] == null) {
            _events[evento.dateTime] = [evento];
          } else {
            _events[evento.dateTime].add(evento);
          }
        });
        print("Events set!");
        _buildTableCalendar();
      });
    });

    _events = {
      DateTime(2020, 1, 1): [new Evento.feriado("Confraternização Universal")],
      DateTime(2020, 2, 24): [new Evento.feriado("Carnaval")],
      DateTime(2020, 2, 25): [new Evento.feriado("Carnaval")],
      DateTime(2020, 2, 26): [new Evento.feriado("Quarta-feira de cinzas")],
      DateTime(2020, 4, 10): [new Evento.feriado("Paixão de Cristo")],
      DateTime(2020, 4, 21): [new Evento.feriado("Tiradentes")],
      DateTime(2020, 5, 1): [new Evento.feriado("Dia Mundial do Trabalho")],
      DateTime(2020, 6, 11): [new Evento.feriado("Corpus Christi")],
      DateTime(2020, 9, 7): [new Evento.feriado("Independência do Brasil")],
      DateTime(2020, 10, 12): [new Evento.feriado("Nossa Senhora Aparecida")],
      DateTime(2020, 10, 28): [new Evento.feriado("Dia do Servidor Público")],
      DateTime(2020, 11, 2): [new Evento.feriado("Finados")],
      DateTime(2020, 12, 15): [new Evento.feriado("Proclamação da República")],
      DateTime(2020, 12, 24): [new Evento.feriado("véspera de natal")],
      DateTime(2020, 12, 25): [new Evento.feriado("Natal")],
      DateTime(2020, 12, 31): [new Evento.feriado("véspera de ano novo ")],
      // _selectedDay.add(Duration(days: 2)): [
      //   new Evento("Aniversario", DateTime.now().add(Duration(days: 2)), descricao: "Evento 1")
      // ],
      // _selectedDay.subtract(Duration(days: 30)): [
      //   new Evento.padrao("Event A0"),
      //   new Evento.padrao("Event B0"),
      //   new Evento.padrao("Event C0")
      // ],
      // _selectedDay.subtract(Duration(days: 27)): [new Evento.padrao("Event A1")],
      // _selectedDay.subtract(Duration(days: 20)): [
      //   new Evento.padrao("Event A2"),
      //   new Evento.padrao("Event B2"),
      //   new Evento.padrao("Event C2"),
      //   new Evento.padrao("Event D2")
      // ],
      // _selectedDay.subtract(Duration(days: 16)): [new Evento.padrao("Event A3"), new Evento.padrao("Event B3")],
      // _selectedDay.subtract(Duration(days: 10)): [
      //   new Evento.padrao("Event A4"),
      //   new Evento.padrao("Event B4"),
      //   new Evento.padrao("Event C4")
      // ],
      // _selectedDay.subtract(Duration(days: 4)): [
      //   new Evento.padrao("Event A5"),
      //   new Evento.padrao("Event B5"),
      //   new Evento.padrao("Event C5")
      // ],
      // _selectedDay.subtract(Duration(days: 2)): [new Evento.padrao("Event A6"), new Evento.padrao("Event B6")],
      // _selectedDay: [
      //   new Evento.padrao("Event A7"),
      //   new Evento.padrao("Event B7"),
      //   new Evento.padrao("Event C7"),
      //   new Evento.padrao("Event D7")
      // ],
      // _selectedDay.add(Duration(days: 1)): [
      //   new Evento.padrao("Event A8"),
      //   new Evento.padrao("Event B8"),
      //   new Evento.padrao("Event C8"),
      //   new Evento.padrao("Event D8")
      // ],
      // _selectedDay.add(Duration(days: 3)): [
      //   new Evento.padrao("Event A9"),
      //   new Evento.padrao("Event A9"),
      //   new Evento.padrao("Event B9")
      // ],
      // _selectedDay.add(Duration(days: 7)): [
      //   new Evento.padrao("Event A1"),
      //   new Evento.padrao("Event B1"),
      //   new Evento.padrao("Event C1")
      // ],
      // _selectedDay.add(Duration(days: 11)): [new Evento.padrao("Event A1"), new Evento.padrao("Event B1")],
      // _selectedDay.add(Duration(days: 17)): [
      //   new Evento.padrao("Event A1"),
      //   new Evento.padrao("Event B1"),
      //   new Evento.padrao("Event C1"),
      //   new Evento.padrao("Event D1")
      // ],
      // _selectedDay.add(Duration(days: 22)): [new Evento.padrao("Event A1"), new Evento.padrao("Event B1")],
      // _selectedDay.add(Duration(days: 25)): [
      //   new Evento.padrao("Evento A1"),
      //   new Evento.padrao("Event B1"),
      //   new Evento.padrao("Event C1"),
      //   new Evento.feriado("Tiradentes")
      // ],
    };
    // Future.wait(_events2);
    _selectedEvents = _events[_selectedDay] ?? [];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      locale: 'pt_BR',
      events: _events,
      holidays: _holidays,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Today',
        // CalendarFormat.week: '',
      },
      daysOfWeekStyle: DaysOfWeekStyle(
          dowTextBuilder: (date, locale) {
            String primeiraLetra = DateFormat.E(locale).format(date)[0].toUpperCase();
            String resto = DateFormat.E(locale).format(date).substring(1).toLowerCase();
            return primeiraLetra + resto;
          },
          weekdayStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          weekendStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent[200],
          )),
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        outsideHolidayStyle: TextStyle(color: Colors.purple, fontSize: 19),
        outsideWeekendStyle: TextStyle(color: Colors.blueAccent[100], fontSize: 19),
        outsideStyle: TextStyle(color: Colors.grey, fontSize: 19),
        selectedColor: Colors.blueAccent[400],
        todayColor: Colors.blueAccent[100],
        weekendStyle: TextStyle(color: Colors.blueAccent[400], fontSize: 19),
        markersColor: Colors.cyan[700],
        outsideDaysVisible: true,
        weekdayStyle: TextStyle(fontSize: 19),
        holidayStyle: TextStyle(color: Colors.purple, fontSize: 19),
        highlightSelected: true,
        highlightToday: true,
      ),
      onHeaderTapped: (x) {
        _calendarController.setSelectedDay(
          DateTime.now(),
          runCallback: true,
        );
      },
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        titleTextStyle: TextStyle(fontSize: 20),
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.blueAccent[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
    );
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pt_BR',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    List<dynamic> _tempEvents = [];
    _tempEvents.addAll(events);
    for (var i = 0; i < _tempEvents.length; i++) {
      if (_tempEvents[i] != null) {
        if (_tempEvents[i].isFeriado) {
          _tempEvents.remove(_tempEvents[i]);
        }
      }
    }
    if (_tempEvents.length == 0) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 1),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${_tempEvents.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text('Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.getNome),
                  subtitle: event.isFeriado ? null : Text(event.getDescricao),
                  onTap: () => print('$event tapped! Nome: ' +
                      event.getNome +
                      " / feriado?: " +
                      event.isFeriado.toString() +
                      " / date: " +
                      event.getDateTime.toString()),
                ),
              ))
          .toList(),
    );
  }
}
