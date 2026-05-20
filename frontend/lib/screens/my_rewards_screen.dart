import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/redeemed_reward.dart';
import '../services/api_service.dart';

class MyRewardsScreen extends StatefulWidget {

  const MyRewardsScreen({super.key});

  @override
  State<MyRewardsScreen> createState() =>
      _MyRewardsScreenState();
}

class _MyRewardsScreenState
    extends State<MyRewardsScreen> {

  late Future<List<RedeemedReward>>
      rewards;

  @override
  void initState() {

    super.initState();

    loadRewards();
  }

  void loadRewards() {

    rewards = ApiService()
        .getRedeemedRewards(1);
  }

  String formatDate(String date) {

    final parsedDate =
        DateTime.parse(date);

    return DateFormat(
      'dd/MM/yyyy - HH:mm',
    ).format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("Mis recompensas"),
      ),

      body:
          FutureBuilder<List<RedeemedReward>>(

        future: rewards,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child:
                  Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;

          if (data.isEmpty) {

            return const Center(
              child: Text(
                "No tienes recompensas canjeadas",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          return RefreshIndicator(

            onRefresh: () async {

              setState(() {

                loadRewards();
              });
            },

            child: ListView.builder(

              itemCount: data.length,

              itemBuilder: (context, index) {

                final reward = data[index];

                return Container(

                  margin:
                      const EdgeInsets.all(12),

                  child: Card(

                    elevation: 6,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              20),
                    ),

                    child: Padding(

                      padding:
                          const EdgeInsets.all(
                              20),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Row(

                            children: [

                              const Icon(
                                Icons.card_giftcard,
                                size: 32,
                                color: Colors.green,
                              ),

                              const SizedBox(
                                  width: 10),

                              Expanded(

                                child: Text(
                                  reward.rewardName,

                                  style:
                                      const TextStyle(
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 20),

                          Container(

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),

                            decoration: BoxDecoration(

                              color: reward.used
                                  ? Colors.red
                                  : Colors.green,

                              borderRadius:
                                  BorderRadius.circular(
                                      20),
                            ),

                            child: Text(

                              reward.used
                                  ? "RECOMPENSA UTILIZADA"
                                  : "DISPONIBLE",

                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          Center(

                            child: Column(

                              children: [

                                const Text(
                                  "Código QR",
                                  style:
                                      TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 15),

                                Image.network(
                                  "http://localhost:8080/redeemed-rewards/qr-image/${reward.id}",

                                  height: 220,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          Row(

                            children: [

                              const Icon(
                                Icons.access_time,
                                size: 20,
                              ),

                              const SizedBox(
                                  width: 8),

                              Expanded(

                                child: Text(
                                  "Canjeada el ${formatDate(reward.redeemedAt)}",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 20),

                          SizedBox(

                            width:
                                double.infinity,

                            child: ElevatedButton.icon(

                              onPressed: reward.used
                                  ? null
                                  : () async {

                                      try {

                                        await ApiService()
                                            .useReward(
                                          reward.id,
                                        );

                                        setState(() {

                                          loadRewards();
                                        });

                                        ScaffoldMessenger
                                                .of(
                                                    context)
                                            .showSnackBar(

                                          SnackBar(
                                            content: Text(
                                              "${reward.rewardName} utilizada correctamente",
                                            ),
                                          ),
                                        );

                                      } catch (e) {

                                        ScaffoldMessenger
                                                .of(
                                                    context)
                                            .showSnackBar(

                                          SnackBar(
                                            content: Text(
                                              e.toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    },

                              icon: const Icon(
                                Icons.check_circle,
                              ),

                              label: Text(
                                reward.used
                                    ? "Ya utilizada"
                                    : "Usar recompensa",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}