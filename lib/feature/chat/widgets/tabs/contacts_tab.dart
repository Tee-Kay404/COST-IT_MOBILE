import 'package:cost_it_mobile/feature/chat/widgets/empty_section.dart';
import 'package:cost_it_mobile/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsTab extends ConsumerWidget {
  final String query;

  const ContactsTab({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // TODO: replace with real contacts provider that reads device contacts
    // and cross-references with Cost-It users
    return Column(
      children: [
        SizedBox(height: 12.h),
        // "On Cost-It" section header
        SectionHeader(label: 'On Cost-It'),
        EmptySection(
          icon: Icons.people_outline,
          message: 'No contacts on Cost-It yet.\nInvite them below!',
        ),

        SizedBox(height: 8.h),
       SectionHeader(label: 'Invite to Cost-It'),
        EmptySection(
          icon: Icons.person_add_outlined,
          message: 'No contacts found.\nMake sure contacts permission is enabled.',
          action: OutlinedButton.icon(
            onPressed: () {
              // TODO: open contact picker via flutter_contacts
            },
            icon: const Icon(Icons.contacts_outlined, size: 18),
            label: const Text('Open Contacts'),
          ),
        ),
      ],
    );
  }
}



