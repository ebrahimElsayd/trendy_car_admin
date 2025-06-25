import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tendy_cart_admin/core/utils/custom_app_bar.dart';
import 'package:tendy_cart_admin/core/utils/custom_txt_btn.dart';
import 'package:tendy_cart_admin/core/utils/custom_txt_field.dart';
import 'package:tendy_cart_admin/core/utils/show_snack_bar.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../riverpods/user_riverpod.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch user data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(appUserRiverpodProvider).user;
      if (user != null && user.id != null) {
        ref.read(userProvider.notifier).getUserInfo(user.id.toString());
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserRiverpodProvider).user;
    final userState = ref.watch(userProvider);

    // Update text controllers when user data is loaded
    ref.listen(userProvider, (previous, next) {
      if (next.isSuccess() && next.username != null) {
        _nameController.text = next.username ?? '';
        _phoneController.text = next.userphone ?? '';
        _emailController.text = next.userEmail ?? '';
        _stateController.text = next.userStateField ?? '';
      }

      if (next.isSuccess() && previous?.state != next.state) {
        // Update the global user state
        if (user != null) {
          ref
              .read(appUserRiverpodProvider.notifier)
              .updateUserData(
                user.copyWith(
                  name: _nameController.text,
                  phone: int.tryParse(_phoneController.text),
                  email: _emailController.text,
                  state: _stateController.text,
                ),
              );
        }
        showSnackBar(context, "Profile updated successfully!");
      } else if (next.isError()) {
        showSnackBar(context, "Error: ${next.errorMessage}");
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:
              userState.isLoading()
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomAppBar(
                        txt: 'Update Profile',
                        hasArrow: true,
                        hasIcons: false,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  // Handle profile picture update
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Color(0xFFFF9E56),
                                  child: const Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name Field
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hinttxt: userState.username ?? "Enter your name",
                        mycontroller: _nameController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),

                      // Email Field (Read-only)
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText:
                              userState.userEmail ??
                              user?.email ??
                              "Email not available",
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 172, 172, 172),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 172, 172, 172),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 200, 200, 200),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Phone Field
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText:
                              userState.userphone ?? "Enter your phone number",
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 172, 172, 172),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 172, 172, 172),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // State Field
                      const Text(
                        'State/Region',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hinttxt:
                            userState.userStateField ??
                            "Enter your state/region",
                        mycontroller: _stateController,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 32),

                      // Display current user info
                      if (userState.isSuccess())
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Current Profile Information',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                'Name',
                                userState.username ?? 'Not set',
                              ),
                              _buildInfoRow(
                                'Email',
                                userState.userEmail ?? 'Not set',
                              ),
                              _buildInfoRow(
                                'Phone',
                                userState.userphone ?? 'Not set',
                              ),
                              _buildInfoRow(
                                'State',
                                userState.userStateField ?? 'Not set',
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),

                      CustomTxtBtn(
                        btnName:
                            userState.isLoading()
                                ? 'Updating...'
                                : 'Update Profile',
                        btnWidth: 1,
                        btnHeight: 40,
                        btnradious: 20,
                        bgclr: Color(0xFFFF9E56),
                        txtstyle: const TextStyle(color: Colors.white),
                        onPress: () {
                          if (!userState.isLoading() && user?.id != null) {
                            ref
                                .read(userProvider.notifier)
                                .updateUser(
                                  user!.id.toString(),
                                  _nameController.text.trim(),
                                  _phoneController.text.trim(),
                                  newState: _stateController.text.trim(),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color.fromARGB(99, 83, 85, 85),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../home/presentation/widgets/custom_txt_field.dart';

// class UserInfoScreen extends ConsumerStatefulWidget {
//   const UserInfoScreen({super.key});

//   @override
//   State<UserInfoScreen> createState() => _UserInfoScreenState();
// }

// class _UserInfoScreenState extends State<UserInfoScreen> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {

//   }
// }

// return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Profile'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     const CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey,
//                       child: Icon(
//                         Icons.person,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: CircleAvatar(
//                         radius: 16,
//                         backgroundColor: Colors.teal,
//                         child: const Icon(
//                           Icons.add,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomTextField(
//                     hinttxt: "Enter your Name",
//                     mycontroller: _nameController,
//                     textInputAction: TextInputAction.next,
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     hinttxt: "Enter your phone",
//                     mycontroller: _phoneController,
//                     textInputAction: TextInputAction.next,
//                   ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text(
//                   'Update Profile',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );\

//    final userId = ref.watch(appUserRiverpodProvider).user!.id!;
