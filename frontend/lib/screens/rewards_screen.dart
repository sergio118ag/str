import 'package:flutter/material.dart';

import '../models/reward.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() =>
      _RewardsScreenState();
}

class _RewardsScreenState
    extends State<RewardsScreen> {

  late Future<List<Reward>> rewards;

  User? currentUser;

  @override
  void initState() {
    super.initState();

    rewards = ApiService().getRewards();

    loadUser();
  }

  Future<void> loadUser() async {

    final loadedUser =
        await ApiService().getUserById(1);

    setState(() {
      currentUser = loadedUser;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Recompensas"),
      ),

      body: Column(

        children: [

          if (currentUser != null)

            Container(

              width: double.infinity,

              margin: const EdgeInsets.all(15),

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.green,

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Column(

                children: [

                  const Text(
                    "Tus puntos actuales",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${currentUser!.points}",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(

            child: FutureBuilder<List<Reward>>(

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
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                final data = snapshot.data!;

                return ListView.builder(

                  itemCount: data.length,

                  itemBuilder: (context, index) {

                    final reward = data[index];

                    return Container(

                      margin:
                          const EdgeInsets.all(12),

                      child: Card(

                        elevation: 5,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),

                        child: Padding(

                          padding:
                              const EdgeInsets.all(
                            20,
                          ),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                reward.name,

                                style:
                                    const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                reward.description,

                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Row(

                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,

                                children: [

                                  Text(
                                    "${reward.pointsRequired} puntos",

                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      color:
                                          Colors
                                              .green,
                                    ),
                                  ),

                                  ElevatedButton(

                                    onPressed: () async {

                                      if (currentUser ==
                                          null) {
                                        return;
                                      }

                                      if (currentUser!
                                              .points <
                                          reward
                                              .pointsRequired) {

                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(

                                          const SnackBar(
                                            content: Text(
                                              "No tienes suficientes puntos",
                                            ),
                                          ),
                                        );

                                        return;
                                      }

                                      try {

                                        await ApiService()
                                            .removePoints(

                                          currentUser!.id,

                                          reward
                                              .pointsRequired,
                                        );

                                        await loadUser();

                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(

                                          SnackBar(
                                            content: Text(
                                              "Has canjeado ${reward.name}",
                                            ),
                                          ),
                                        );

                                      } catch (e) {

                                        ScaffoldMessenger.of(
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

                                    child:
                                        const Text(
                                      "Canjear",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}