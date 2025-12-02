import '../models/station_model.dart';
import '../models/program_model.dart';

const stations = <Station>[
  Station(
    name: 'Live Jazz Radio',
    acronym: 'LJR',
    url: 'https://stream.freepi.io:8012/live',
    slogan: 'La síncopa de nuestras latitudes',
    imageAsset: 'assets/images/station2.png',
  ),
  Station(
    name: 'Radioactiva Tx',
    acronym: 'RTX',
    url: 'https://stream.laut.fm/lofi',
    slogan: '¡La Radio Alternativa!',
    imageAsset: 'assets/images/station1.png',
  ),
];

const programs = <Program>[
  Program(
    title: 'DR. YESCA SHOW',
    description:
        'En Radioactiva TX, nos encanta ser tu compañía en cada momento del día. Desde la música más vibrante hasta las noticias más relevantes, estamos aquí para mantenerte informado y entretenido. Sintonízanos y déjanos ser parte de tu día.',
    imageAsset: 'assets/images/prog1.png',
    schedules: [
      ProgramSchedule(day: 'Viernes', start: '06:00 PM', end: '07:00 PM'),
      ProgramSchedule(day: 'Sábado', start: '01:00 PM', end: '02:00 PM'),
    ],
  ),
  Program(
    title: 'AL COMPÁS DEL MUNDO',
    description:
        'En Radioactiva TX, nos encanta ser tu compañía en cada momento del día. Desde la música más vibrante hasta las noticias más relevantes, estamos aquí para mantenerte informado y entretenido. Sintonízanos y déjanos ser parte de tu día',
    imageAsset: 'assets/images/prog2.png',
    schedules: [
      ProgramSchedule(day: 'Jueves', start: '03:00 PM', end: '04:00 PM'),
      ProgramSchedule(day: 'Sábado', start: '03:00 PM', end: '04:00 PM'),
    ],
  ),
  Program(
    title: 'EL LIBRERO',
    description:
        'En Radioactiva TX, nos encanta ser tu compañía en cada momento del día. Desde la música más vibrante hasta las noticias más relevantes, estamos aquí para mantenerte informado y entretenido. Sintonízanos y déjanos ser parte de tu día.',
    imageAsset: 'assets/images/prog3.png',
    schedules: [
      ProgramSchedule(day: 'Martes', start: '03:00 PM', end: '04:00 PM'),
      ProgramSchedule(day: 'Sábado', start: '10:00 AM', end: '11:00 AM'),
    ],
  ),
  Program(
    title: 'GAB VANIAN',
    description:
        'En Radioactiva TX, nos encanta ser tu compañía en cada momento del día. Desde la música más vibrante hasta las noticias más relevantes, estamos aquí para mantenerte informado y entretenido. Sintonízanos y déjanos ser parte de tu día',
    imageAsset: 'assets/images/prog4.png',
    schedules: [
      ProgramSchedule(day: 'Lunes', start: '05:00 PM', end: '06:00 PM'),
      ProgramSchedule(day: 'Martes', start: '05:00 PM', end: '06:00 PM'),
      ProgramSchedule(day: 'Miercoles', start: '05:00 PM', end: '06:00 PM'),
      ProgramSchedule(day: 'Jueves', start: '05:00 PM', end: '06:00 PM'),
    ],
  ),
];
