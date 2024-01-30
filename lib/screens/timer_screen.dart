import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';
import 'package:planla/utiles/colors.dart';
import 'package:planla/widgets/textField/textinputfield_widget.dart';
import 'package:planla/widgets/timer_widget.dart';
import 'package:provider/provider.dart';
import '../controls/firebase/firestore._methods.dart';
import '../widgets/buttons/timer_button_widget.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? timer;
  int hoursNumeric = 0;
  int minuteNumeric = 0;
  int secendNumeric = 0;
  String _event = '';
  List<bool> checkboxList = [];

  @override
  void initState() {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    providerUser.setEvent('', false);

    timerProvider.reset();
    checkboxListUpdate(false);
    super.initState();
  }

  void checkboxListUpdate(bool control) {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    checkboxList.clear();
    for (int i = 0; i < providerUser.getEventsString.length; i++) {
      checkboxList.add(false);
    }
    providerUser.setCheckBoxList(checkboxList, control);
  }

  void checkBoxSetValue(int index, BuildContext context) {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    checkboxList = providerUser.getCheckBoxList;
    for (int i = 0; i < providerUser.getEventsString.length; i++) {
      if (i == index) {
        checkboxList[i] = true;
      } else {
        checkboxList[i] = false;
      }
    }
    providerUser.setCheckBoxList(checkboxList, true);
  }

  @override
  Widget build(BuildContext context) {
    TimerProvider providerTimer =
        Provider.of<TimerProvider>(context, listen: false);
    ProviderUser providerUser = Provider.of<ProviderUser>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: size.height / 80,
        ),
        child: GestureDetector(
          onTap: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            providerUser.getLanguage ? 'Ekle' : 'Add',
                            style: TextStyle(
                                color: primeryColor,
                                fontSize: size.width / 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.height / 45, bottom: size.height / 80),
                        child: Text(
                          providerUser.getLanguage
                              ? 'Yeni etkinliğinizi ekleyin'
                              : 'Add your new event',
                          style: TextStyle(
                              color: const Color(0xff26303b),
                              fontWeight: FontWeight.w400,
                              fontSize: size.width / 20),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 2,
                        height: size.height / 12,
                        child: TextInputField(
                          controlCaptalWord: true,
                            autofocusControl: true,
                            onSubmited: (v) {},
                            inputLenghtControl: true,
                            hintText: providerUser.getLanguage
                                ? 'Yeni etkinlik ekle'
                                : 'Add new activity',
                            labelTextWidget: Text(
                              providerUser.getLanguage
                                  ? '10 karaktere kadar'
                                  : 'up to 10 characters',
                            ),
                            iconWidget: const SizedBox(),
                            obscrueText: false,
                            onchange: (v) {
                              _event = v;
                            },
                            hintColor: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height / 25),
                        child: Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () async {
                                await FirestoreMethods()
                                    .saveEvent(context, _event);
                                checkboxListUpdate(true);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                  providerUser.getLanguage ? 'Evet' : 'Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                  providerUser.getLanguage ? 'Hayır' : 'No'),
                            ),
                            const Spacer()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          child: Container(
            width: size.width / 8,
            height: size.height / 15,
            decoration:
                BoxDecoration(color: navigatorColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width / 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: providerTimer.timerScreenType
          ? buildTimerSetScreen(providerUser)
          : buildTimerCountScreen(providerUser),
    );
  }

  Widget buildTimerCountScreen(ProviderUser providerUser) {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: true);

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size.height / 25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              child: Row(
                children: [
                  const Spacer(),
                  TimerWidget(
                      providerUser: providerUser,
                      hours: timerProvider.getdenemeHours,
                      minutes: timerProvider.getdenemeMinute,
                      secends: timerProvider.getdenemeSecend),
                  const Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 50),
                    child: SizedBox(
                      width: size.width,
                      height: size.height / 3.2,
                      child: Lottie.network(
                        timerProvider.getMotivationLttieUrl,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                        left: size.width / 10,
                        right: size.width / 10,
                        top: size.height / 80),
                    child: Text(
                      providerUser.getLanguage
                          ? timerProvider.getMotivationSentencesTur
                          : timerProvider.getMotivationSentencesEn,
                      softWrap: true,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width / 22,
                        wordSpacing: 0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            buildButton(providerUser),
          ],
        ),
      ),
    );
  }

  firestoreSvae(TimerProvider timerProvider)  {
     FirestoreMethods().updateScoreAndEventsValue(context);

    FirestoreMethods().updateArrangement(context);

    print('geliyottttt');
    timerProvider.setTimerFinishControl(false);
  }

  Widget buildTimerSetScreen(ProviderUser providerUser) {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: true);
    checkboxList = providerUser.getCheckBoxList;
    Size size = MediaQuery.of(context).size;
    if (timerProvider.getTimerFinishControl) {
      firestoreSvae(timerProvider);
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height / 50,
          ),
          /*   SizedBox(
              width: size.width,
              height:100,
              child: Row(
                children: [
                  const Spacer(),
                  TimerWidget(
                    hours: hoursNumeric < 10
                        ? '0$hoursNumeric'
                        : hoursNumeric.toString(),
                    minutes: minuteNumeric < 10
                        ? '0$minuteNumeric'
                        : minuteNumeric.toString(),
                    secends: secendNumeric < 10
                        ? '0$secendNumeric'
                        : secendNumeric.toString(),
                  ),
                  const Spacer(),
                ],
              )),*/
          Padding(
            padding: EdgeInsets.only(
                //        top: size.height / 25,
                left: size.width / 25,
                right: size.width / 25),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    buildNumericText(
                        size, providerUser.getLanguage ? 'Saat' : 'Hours'),
                    numeric(
                      current: hoursNumeric,
                      onChanged: (value) {
                        setState(() {
                          hoursNumeric = value;
                        });
                        timerProvider.reset();
                      },
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    buildNumericText(
                        size, providerUser.getLanguage ? 'Dakika' : 'Minute'),
                    numeric(
                      current: minuteNumeric,
                      onChanged: (value) {
                        setState(() {
                          minuteNumeric = value;
                        });
                        timerProvider.reset();
                      },
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    buildNumericText(
                        size, providerUser.getLanguage ? 'Saniye' : 'Secend'),
                    numeric(
                      current: secendNumeric,
                      onChanged: (value) {
                        setState(() {
                          secendNumeric = value;
                        });
                        timerProvider.reset();
                      },
                    ),
                  ],
                )),
              ],
            ),
          ),
          /* Padding(
            padding:
                EdgeInsets.only(left: size.height / 25, top: size.height / 25),
            child: SizedBox(
              width: size.width / 2,
              height: size.height / 5,
              child: AddTextfieldWidget(onSubmit: (v) {}),
            ),
          ),*/
          Padding(
            padding: EdgeInsets.only(top: size.height / 25),
            child: SizedBox(
              height: size.height / 2.6,
              width: size.width,
              child: providerUser.getEventsString.isEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          width: size.width,
                          height: size.height / 3.5,
                          child: Lottie.network(
                              'https://lottie.host/62c43383-e871-430e-8e0b-6dde45b772fa/Xdx9EidvGt.json'),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.width / 6),
                          child: Text(
                            providerUser.getLanguage
                                ? 'Herhangi bir etkinliğiniz yok, önce en az bir etkinlik eklemelisiniz'
                                : 'You don\'t have any events, you must add at least one event first ',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.grey, fontSize: size.width / 25),
                          ),
                        )
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: size.width / 15),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: size.width / 2,
                          childAspectRatio: size.height / 200,
                          crossAxisSpacing: size.height / 20,
                          mainAxisSpacing: size.width / 25,
                        ),
                        itemCount: providerUser.getEventsString.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (_, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (DismissDirection direction) async {
                              await FirestoreMethods()
                                  .deleteEvent(context, index);
                            },
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Checkbox(
                                      value:
                                          providerUser.getCheckBoxList[index],
                                      onChanged: (value) {
                                        buildCheckBoxxOnTapFunction(
                                            index, providerUser);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        buildCheckBoxxOnTapFunction(
                                            index, providerUser);
                                      },
                                      child: Text(
                                        providerUser.getEventsString[index],
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: const Color(0xff193242),
                                          fontSize: size.width / 30,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              SizedBox(
                width: size.width / 3,
                height: size.height / 12,
                child: InkWell(
                  onTap: () {
                    if (providerUser.getEventsString.isNotEmpty &&
                        providerUser.getEvent.isNotEmpty) {
                      timerProvider.setHours(hoursNumeric);
                      timerProvider.setMinute(minuteNumeric);
                      timerProvider.setSecends(secendNumeric);
                      //int temp=hoursNumeric+minuteNumeric+secendNumeric;
                      timerProvider.setTempScore();
                      timerProvider.setEventTime();
                      timerProvider.startTime(resets: false);
                      timerProvider.setTimerScreenType(false);
                      // BackgroundService().initSercice(context);
                      timerProvider.reset();
                      /*
                      bu deneme amaçlı yazılmış bir kod
                      Arrangment arrangement1=Arrangment(imgUrl: '', uid: '', name: 'birinci', score: 0);
                      Arrangment arrangement2=Arrangment(imgUrl: '', uid: '', name: 'ikinci', score: 0);
                      Arrangment arrangement3=Arrangment(imgUrl: '', uid: '', name: 'üçüncü', score: 0);
                      firestore.collection('arrangement').doc('scors').set({
                        '1':arrangement1.toMap(),
                        '2':arrangement2.toMap(),
                        '3':arrangement3.toMap(),
                      });*/

                      //BackgroundService().initSercice(hoursNumeric,minuteNumeric,secendNumeric);
                    }
                  },
                  child: providerUser.getEventsString.isNotEmpty
                      ? TimerButtonWidget(
                          radiusControl: true,
                          color: providerUser.getEventsString.isNotEmpty &&
                                  providerUser.getEvent.isNotEmpty
                              ? primeryColor
                              : Colors.grey,
                          txt: providerUser.getLanguage ? 'Başla' : 'Go',
                        )
                      : const SizedBox(),
                ),
              ),
              /*  Padding(
                padding: EdgeInsets.only(right: size.width / 40),
                child: Container(
                  //margin: EdgeInsets.only(bottom: size.height/12),
                  width: size.width / 8,
                  height: size.height / 12,
                  decoration: BoxDecoration(
                      color: primeryColor, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),*/
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }

  void buildCheckBoxxOnTapFunction(int index, ProviderUser providerUser) {
    checkBoxSetValue(index, context);
    providerUser.setEvent(providerUser.getEventsString[index], true);
    providerUser.setValueEvent(providerUser.getEventsValueList[index]);
  }

  Widget buildNumericText(Size size, String txt) {
    return Padding(
      padding: EdgeInsets.only(top: size.height / 80, bottom: size.height / 80),
      child: Text(
        txt,
        style: TextStyle(
            color: Colors.grey,
            fontSize: size.width / 20,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget buildButton(ProviderUser providerUser) {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: true);
    bool type =
        timerProvider.timer == null ? false : timerProvider.timer!.isActive;
    Size size = MediaQuery.of(context).size;
    // final isComplated = duration.inSeconds == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: InkWell(
            onTap: () {
              if (type) {
                timerProvider.stop(resets: false);
              } else {
                timerProvider.startTime(resets: false);
              }
            },
            child: SizedBox(
              width: size.width / 3,
              height: size.height / 13,
              child: providerUser.getLanguage
                  ? TimerButtonWidget(
                      radiusControl: true,
                      color: timerProvider.getCounter != 0
                          ? Colors.black
                          : Colors.grey,
                      txt: type ? 'Durdur' : 'Devam',
                    )
                  : TimerButtonWidget(
                      radiusControl: true,
                      color: timerProvider.getCounter != 0
                          ? Colors.black
                          : Colors.grey,
                      txt: type ? 'Stop' : 'Resume',
                    ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: size.width / 25),
          child: GestureDetector(
            onTap: () {
              setState(() {
                timerProvider.stop(resets: true);
                timerProvider.setTimerScreenType(true);
                timerProvider.setTimerReset('00');
              });
            },
            child: SizedBox(
              width: size.width / 3,
              height: size.height / 13,
              child: TimerButtonWidget(
                radiusControl: true,
                color: Colors.black,
                txt: providerUser.getLanguage ? 'Sıfırla' : 'Reset',
              ),
            ),
          ),
        ),
        //   Spacer(),
      ],
    );
  }

  Widget numeric({required int current, required ValueChanged<int> onChanged}) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff2a2a2a),
        borderRadius: BorderRadius.all(Radius.circular(size.width / 25)),
      ),
      child: Column(
        children: <Widget>[
          NumberPicker(
            value: current,
            minValue: 0,
            maxValue: 59,
            selectedTextStyle:
                TextStyle(color: Colors.white, fontSize: size.width / 20),
            textStyle: const TextStyle(color: Colors.white70),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

/*  Map<String, dynamic> convertList(List<Map<String, dynamic>> originalList) {
    Map<String, dynamic> resultMap = {};

    // "eventsMap" altındaki anahtarları kullanarak Map oluştur
    var eventsMapList = originalList[1]["eventsMap"];
    for (var map in eventsMapList) {
      if (map is Map) {
        map.forEach((key, value) {
          resultMap[key] = value;
        });
      }
    }

    return resultMap;
  }

  List<dynamic> removeElementByKey(List<dynamic> dataList, String keyToRemove) {
    for (var element in dataList) {
      if (element is Map) {
        // Eğer Map'in anahtarları arasında keyToRemove varsa, bu Map'i listeden çıkar
        if (element.containsKey(keyToRemove)) {
          dataList.remove(element);
          break; // Eğer sadece bir eşleşme istiyorsanız bu break kullanılabilir
        } else {
          // Eğer bir eşleşme bulunamazsa, alt elemanlara bakmak için fonksiyonu tekrar çağır
          removeElementByKey(element.values.toList(), keyToRemove);
        }
      } else if (element is List) {
        // Eğer eleman bir liste ise, alt elemanlara bakmak için fonksiyonu tekrar çağır
        removeElementByKey(element, keyToRemove);
      }
    }
    return dataList;
  }*/

/*  Map<String, dynamic> removeEventFromList(
      List<Map<String, dynamic>> eventsList, String keyToRemove) {
    eventsList.removeWhere((event) {
      // Belirtilen key'e sahipse, bu elemanı listeden çıkar
      if (event.containsKey('eventsMap')) {
        event['eventsMap']
            .removeWhere((innerEvent) => innerEvent.containsKey(keyToRemove));

        // Eğer iç içe olan alt liste (eventsMap) boşsa, ana listeden de çıkar
        return event['eventsMap'].isEmpty;
      }
      return false;
    });

    // convertedMap'i buraya taşıdık, bu şekilde fonksiyonun sonunda döndürebiliriz
    Map<String, dynamic> convertedMap = {'eventsList': eventsList};
    return convertedMap;
  }*/
}
