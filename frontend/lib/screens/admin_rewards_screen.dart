import 'package:flutter/material.dart';
import '../models/reward.dart';
import '../services/api_service.dart';

class AdminRewardsScreen extends StatefulWidget {
  const AdminRewardsScreen({super.key});

  @override
  State<AdminRewardsScreen> createState() => _AdminRewardsScreenState();
}

class _AdminRewardsScreenState extends State<AdminRewardsScreen> {
  late Future<List<Reward>> rewards;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadRewards();
  }

  void loadRewards() {
    setState(() {
      rewards = ApiService().getAllRewardsAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestionar Recompensas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadRewards,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Reward>>(
        future: rewards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Text("No hay recompensas creadas"),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final reward = data[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: reward.active ? Colors.green : Colors.red,
                    child: Icon(
                      reward.active ? Icons.check : Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    reward.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reward.description),
                      const SizedBox(height: 5),
                      Text(
                        "${reward.pointsRequired} puntos",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!reward.active)
                        const Text(
                          "INACTIVA",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(reward);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          reward.active ? Icons.block : Icons.restore,
                          color: reward.active ? Colors.orange : Colors.green,
                        ),
                        onPressed: () {
                          _toggleRewardStatus(reward);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog() {
    _nameController.clear();
    _descriptionController.clear();
    _pointsController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Crear Recompensa"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un nombre";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa una descripción";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pointsController,
                  decoration: const InputDecoration(
                    labelText: "Puntos requeridos",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa los puntos";
                    }
                    if (int.tryParse(value) == null) {
                      return "Ingresa un número válido";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: _createReward,
            child: const Text("Crear"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Reward reward) {
    _nameController.text = reward.name;
    _descriptionController.text = reward.description;
    _pointsController.text = reward.pointsRequired.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Recompensa"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa un nombre";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa una descripción";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pointsController,
                  decoration: const InputDecoration(
                    labelText: "Puntos requeridos",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingresa los puntos";
                    }
                    if (int.tryParse(value) == null) {
                      return "Ingresa un número válido";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => _updateReward(reward.id),
            child: const Text("Actualizar"),
          ),
        ],
      ),
    );
  }

  void _createReward() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await ApiService().createReward({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'pointsRequired': int.parse(_pointsController.text),
        });
        Navigator.pop(context);
        loadRewards();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Recompensa creada correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _updateReward(int rewardId) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await ApiService().updateRewardAdmin(rewardId, {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'pointsRequired': int.parse(_pointsController.text),
        });
        Navigator.pop(context);
        loadRewards();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Recompensa actualizada correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleRewardStatus(Reward reward) async {
    try {
      await ApiService().updateRewardAdmin(reward.id, {
        'name': reward.name,
        'description': reward.description,
        'pointsRequired': reward.pointsRequired,
        'active': !reward.active,
      });
      loadRewards();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reward.active
                ? "Recompensa desactivada"
                : "Recompensa activada",
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }
}