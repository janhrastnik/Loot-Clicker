import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'progressbar.dart';
import '../blocs.dart';
import '../globals.dart';
import 'merchant.dart';
import 'dart:math';

class Prompt extends StatelessWidget {
  final PromptBloc promptBloc;
  final ClickerBloc clickerBloc;
  final DungeonBloc dungeonBloc;
  final HeroHpBloc heroHpBloc;

  Prompt({this.promptBloc, this.clickerBloc, this.dungeonBloc, this.heroHpBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: promptBloc,
        builder: (BuildContext context, String event) {
          if (event == "EventType.fight") { // show fight prompt
            int fleeCalculation = 50 + player.agility * 25 - gameData.dungeonTiles[1].event.enemy.agility * 25;
            if (fleeCalculation > 100) {
              fleeCalculation = 100;
            } else if (fleeCalculation < 25) {
              fleeCalculation = 25;
            }
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(gameData.dungeonTiles[1].event.enemy.displayName),
                ),
                ProgressBar(clickerBloc),
                Expanded(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            height: MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black)
                            ),
                            child: MaterialButton(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width/4,
                                        height: MediaQuery.of(context).size.width/4,
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image(image: AssetImage("assets/attack.png")),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text("Attack"),
                                      )
                                ],
                              ),
                              onPressed: () {
                                if (!gameData.isScrolling) {
                                  clickerBloc.dispatch(gameData.dungeonTiles);
                                  characterStream.sink.add(CharacterState.attack);
                                  wait(1).then((value) => characterStream.sink.add(CharacterState.idle));
                                }
                              },
                            ),
                          ),
                          Text("Crit Chance: ${(player.criticalHitChance*100).floor()} %")
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            height: MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black)
                            ),
                            child: MaterialButton(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width/4,
                                    height: MediaQuery.of(context).size.width/4,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image(image: AssetImage("assets/flee.png")),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("Flee"),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (!gameData.isScrolling) {
                                  double fleeRoll = Random().nextDouble();
                                  print("fleeRoll was $fleeRoll");
                                  if (fleeRoll < (fleeCalculation / 100)) {
                                    promptBloc.dispatch("leave");
                                    clickerBloc.dispatch([]);
                                  } else {
                                    gameData.failedFlee = true;
                                    clickerBloc.dispatch(gameData.dungeonTiles);
                                    print("fleeRoll failed");
                                  }
                                }
                              },
                            ),
                          ),
                          Text("Flee Chance: $fleeCalculation %")
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (event == "EventType.merchant") {
            return Column(
              children: <Widget>[
                ProgressBar(clickerBloc),
                Expanded(
                  child: Merchant(dungeonBloc, clickerBloc, promptBloc),
                )
              ],
            );
          } else if (event == "EventType.fountain") {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("Fountain"),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            height: MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black)
                            ),
                            child: MaterialButton(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width/4,
                                    height: MediaQuery.of(context).size.width/4,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image(image: AssetImage("assets/attack.png")),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("Drink"),
                                  )
                                ],
                              ),
                              onPressed: () {
                                heroHpBloc.dispatch(1*player.dungeonLevel);
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            height: MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black)
                            ),
                            child: MaterialButton(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width/4,
                                    height: MediaQuery.of(context).size.width/4,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image(image: AssetImage("assets/flee.png")),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("Leave"),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (!gameData.isScrolling) {
                                    promptBloc.dispatch("leave");
                                    clickerBloc.dispatch([]);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
        } else if (event == "transition" || event == "death") {
            return Container();
          } else {
            return ProgressBar(clickerBloc);
          }
        });
  }
}