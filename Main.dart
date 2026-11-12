import 'package:flutter/material.dart';

void main() => runApp(const BloodDonorApp());

const Color primaryRed = Color(0xFFD62839);
const Color darkRed = Color(0xFFAA1424);
const Color paleRed = Color(0xFFFFEEF0);
const Color pageBg = Color(0xFFF8F8FA);
const List<String> bloodGroups = [
  'All',
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-'
];

class Donor {
  final String name, blood, phone, city;
  final int age;
  bool available;
  Donor(
      {required this.name,
      required this.blood,
      required this.phone,
      required this.city,
      required this.age,
      this.available = true});
}

class BloodRequest {
  final String patient, blood, hospital, city, units, phone;
  final DateTime created;
  BloodRequest(
      {required this.patient,
      required this.blood,
      required this.hospital,
      required this.city,
      required this.units,
      required this.phone,
      required this.created});
}

class BloodDonorApp extends StatefulWidget {
  const BloodDonorApp({super.key});
  @override
  State<BloodDonorApp> createState() => _BloodDonorAppState();
}

class _BloodDonorAppState extends State<BloodDonorApp> {
  int selectedTab = 0;
  String userName = 'Blood Connect Member';
  String userCity = 'Bhimavaram';
  final List<Donor> donors = [];
  final List<BloodRequest> requests = [];
  final Set<String> favorites = {};

  void addDonor(Donor donor) => setState(() => donors.add(donor));
  void addRequest(BloodRequest request) =>
      setState(() => requests.insert(0, request));
  void toggleFavorite(Donor donor) => setState(() {
        if (favorites.contains(donor.phone)) {
          favorites.remove(donor.phone);
        } else {
          favorites.add(donor.phone);
        }
      });

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
          userName: userName,
          donors: donors,
          requests: requests,
          onNavigate: (i) => setState(() => selectedTab = i)),
      FindDonorsPage(
          donors: donors, favorites: favorites, onFavorite: toggleFavorite),
      RegisterPage(onRegister: (d) {
        addDonor(d);
        setState(() => selectedTab = 1);
      }),
      RequestsPage(requests: requests, onAdd: addRequest),
      ProfilePage(
          userName: userName,
          city: userCity,
          donorCount: donors.length,
          requestCount: requests.length,
          onSave: (n, c) => setState(() {
                userName = n;
                userCity = c;
              })),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Connect',
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: pageBg,
          colorScheme:
              ColorScheme.fromSeed(seedColor: primaryRed, primary: primaryRed),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF20202A),
              elevation: 0),
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFFF7F7F8),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: primaryRed, width: 1.4)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15))),
      home: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        return Scaffold(
          body: SafeArea(
              child: Row(children: [
            if (wide)
              NavigationRail(
                  backgroundColor: Colors.white,
                  selectedIndex: selectedTab,
                  onDestinationSelected: (i) => setState(() => selectedTab = i),
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child:
                          Icon(Icons.bloodtype, color: primaryRed, size: 34)),
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home')),
                    NavigationRailDestination(
                        icon: Icon(Icons.search), label: Text('Find Donors')),
                    NavigationRailDestination(
                        icon: Icon(Icons.person_add_alt_1),
                        label: Text('Register')),
                    NavigationRailDestination(
                        icon: Icon(Icons.volunteer_activism_outlined),
                        label: Text('Requests')),
                    NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        label: Text('Profile')),
                  ]),
            Expanded(
                child: Column(children: [
              if (wide)
                Container(
                    height: 62,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    color: Colors.white,
                    child: Row(children: [
                      const Icon(Icons.bloodtype, color: primaryRed),
                      const SizedBox(width: 10),
                      const Text('Blood Connect',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const Spacer(),
                      const Text('Find donors. Save lives.',
                          style: TextStyle(color: Colors.black54))
                    ])),
              Expanded(
                  child: IndexedStack(index: selectedTab, children: pages)),
            ])),
          ])),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  backgroundColor: Colors.white,
                  selectedIndex: selectedTab,
                  onDestinationSelected: (i) => setState(() => selectedTab = i),
                  destinations: const [
                      NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: 'Home'),
                      NavigationDestination(
                          icon: Icon(Icons.search), label: 'Find'),
                      NavigationDestination(
                          icon: Icon(Icons.person_add_alt_1),
                          label: 'Register'),
                      NavigationDestination(
                          icon: Icon(Icons.volunteer_activism_outlined),
                          label: 'Requests'),
                      NavigationDestination(
                          icon: Icon(Icons.person_outline), label: 'Profile'),
                    ]),
        );
      }),
    );
  }
}

class PageFrame extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const PageFrame(
      {super.key,
      required this.title,
      required this.child,
      this.subtitle = ''});
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold)),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54))
              ]
            ])),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1050),
                        child: child)))),
      ]);
}

class HomePage extends StatelessWidget {
  final String userName;
  final List<Donor> donors;
  final List<BloodRequest> requests;
  final ValueChanged<int> onNavigate;
  const HomePage(
      {super.key,
      required this.userName,
      required this.donors,
      required this.requests,
      required this.onNavigate});
  @override
  Widget build(BuildContext context) => PageFrame(
      title: 'Home',
      subtitle: 'Every drop counts. Be someone’s reason to smile.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [primaryRed, darkRed]),
                borderRadius: BorderRadius.circular(22)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.favorite, color: Colors.white, size: 34),
              const SizedBox(height: 14),
              const Text('Welcome to Blood Connect',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 7),
              const Text('Your small act of kindness can save a life.',
                  style: TextStyle(color: Colors.white70, fontSize: 15)),
              const SizedBox(height: 20),
              Wrap(spacing: 10, runSpacing: 10, children: [
                FilledButton.icon(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryRed),
                    onPressed: () => onNavigate(1),
                    icon: const Icon(Icons.search),
                    label: const Text('Find a donor')),
                OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white)),
                    onPressed: () => onNavigate(3),
                    icon: const Icon(Icons.add),
                    label: const Text('Request blood'))
              ])
            ])),
        const SizedBox(height: 22),
        const Text('Your community at a glance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, c) {
          final count = c.maxWidth > 650 ? 3 : 1;
          final w = (c.maxWidth - (count - 1) * 12) / count;
          return Wrap(spacing: 12, runSpacing: 12, children: [
            StatCard(
                width: w,
                icon: Icons.people_alt_outlined,
                value: '${donors.length}',
                label: 'Registered donors'),
            StatCard(
                width: w,
                icon: Icons.bloodtype_outlined,
                value: '${bloodGroups.length - 1}',
                label: 'Blood groups'),
            StatCard(
                width: w,
                icon: Icons.medical_services_outlined,
                value: '${requests.length}',
                label: 'Blood requests')
          ]);
        }),
        const SizedBox(height: 24),
        const Text('Quick actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, c) {
          final w = c.maxWidth > 650 ? (c.maxWidth - 12) / 2 : c.maxWidth;
          return Wrap(spacing: 12, runSpacing: 12, children: [
            ActionTile(
                width: w,
                icon: Icons.person_add_alt,
                title: 'Become a donor',
                detail: 'Register your details and help others.',
                onTap: () => onNavigate(2)),
            ActionTile(
                width: w,
                icon: Icons.search,
                title: 'Search donors',
                detail: 'Find donors by blood group.',
                onTap: () => onNavigate(1)),
            ActionTile(
                width: w,
                icon: Icons.campaign_outlined,
                title: 'Post a blood request',
                detail: 'Share an urgent blood requirement.',
                onTap: () => onNavigate(3)),
            ActionTile(
                width: w,
                icon: Icons.person_outline,
                title: 'My profile',
                detail: 'View and update your profile.',
                onTap: () => onNavigate(4))
          ]);
        }),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: paleRed,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: primaryRed),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please confirm donor availability and eligibility with a licensed blood bank or healthcare professional. For emergencies, contact local emergency services.',
                ),
              ),
            ],
          ),
        ),
      ]));
}

class StatCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String value, label;
  const StatCard(
      {super.key,
      required this.width,
      required this.icon,
      required this.value,
      required this.label});
  @override
  Widget build(BuildContext context) => Container(
      width: width,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(17)),
      child: Row(children: [
        Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
                color: paleRed, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: primaryRed)),
        const SizedBox(width: 13),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 12))
        ])
      ]));
}

class ActionTile extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title, detail;
  final VoidCallback onTap;
  const ActionTile(
      {super.key,
      required this.width,
      required this.icon,
      required this.title,
      required this.detail,
      required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
          width: width,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Icon(icon, color: primaryRed, size: 28),
            const SizedBox(width: 13),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(detail,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 12))
                ])),
            const Icon(Icons.chevron_right, color: Colors.black38)
          ])));
}

class FindDonorsPage extends StatefulWidget {
  final List<Donor> donors;
  final Set<String> favorites;
  final ValueChanged<Donor> onFavorite;
  const FindDonorsPage(
      {super.key,
      required this.donors,
      required this.favorites,
      required this.onFavorite});
  @override
  State<FindDonorsPage> createState() => _FindDonorsPageState();
}

class _FindDonorsPageState extends State<FindDonorsPage> {
  String group = 'All';
  bool onlyAvailable = false;
  bool onlyFavorites = false;
  String query = '';
  @override
  Widget build(BuildContext context) {
    final results = widget.donors
        .where((d) =>
            (group == 'All' || d.blood == group) &&
            (!onlyAvailable || d.available) &&
            (!onlyFavorites || widget.favorites.contains(d.phone)) &&
            ('${d.name} ${d.city} ${d.blood}'
                .toLowerCase()
                .contains(query.toLowerCase())))
        .toList();
    return PageFrame(
        title: 'Find blood donors',
        subtitle: 'Search registered donors by blood group or location.',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search name, blood group or city')),
          const SizedBox(height: 15),
          const Text('Blood group',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 9),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: bloodGroups
                  .map((g) => ChoiceChip(
                      label: Text(g),
                      selected: group == g,
                      selectedColor: paleRed,
                      onSelected: (_) => setState(() => group = g)))
                  .toList()),
          const SizedBox(height: 8),
          SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: primaryRed,
              title: const Text('Available donors only'),
              value: onlyAvailable,
              onChanged: (v) => setState(() => onlyAvailable = v)),
          SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: primaryRed,
              title: const Text('Show favourite donors only'),
              value: onlyFavorites,
              onChanged: (v) => setState(() => onlyFavorites = v)),
          const SizedBox(height: 8),
          Row(children: [
            Text('${results.length} donor(s) found',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton(
                onPressed: () => setState(() {
                      group = 'All';
                      onlyAvailable = false;
                      query = '';
                    }),
                child: const Text('Clear filters'))
          ]),
          if (results.isEmpty)
            const EmptyState(
                icon: Icons.search_off,
                title: 'No donors found',
                detail: 'Try another blood group or search term.'),
          ...results.map((d) => DonorCard(
              donor: d,
              favorite: widget.favorites.contains(d.phone),
              onFavorite: () => widget.onFavorite(d))),
        ]));
  }
}

class DonorCard extends StatelessWidget {
  final Donor donor;
  final bool favorite;
  final VoidCallback onFavorite;
  const DonorCard(
      {super.key,
      required this.donor,
      required this.favorite,
      required this.onFavorite});
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(17)),
      child: Row(children: [
        CircleAvatar(
            radius: 25,
            backgroundColor: paleRed,
            child: Text(donor.blood,
                style: const TextStyle(
                    color: primaryRed, fontWeight: FontWeight.bold))),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(donor.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text('${donor.age} years • ${donor.city}',
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 6),
          Row(children: [
            Icon(Icons.circle,
                size: 8, color: donor.available ? Colors.green : Colors.grey),
            const SizedBox(width: 5),
            Text(donor.available ? 'Available' : 'Currently unavailable',
                style: TextStyle(
                    fontSize: 11,
                    color: donor.available ? Colors.green : Colors.grey))
          ])
        ])),
        IconButton(
            onPressed: onFavorite,
            icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                color: primaryRed)),
        IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                        title: Text(donor.name),
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Blood group: ${donor.blood}'),
                              Text('Age: ${donor.age}'),
                              Text('Location: ${donor.city}'),
                              Text('Phone: ${donor.phone}'),
                              const SizedBox(height: 10),
                              const Text(
                                  'Please contact the donor to confirm current availability. Donor eligibility must be assessed by a qualified healthcare professional.')
                            ]),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'))
                        ])),
            icon: const Icon(Icons.visibility_outlined, color: primaryRed))
      ]));
}

class RegisterPage extends StatefulWidget {
  final ValueChanged<Donor> onRegister;
  const RegisterPage({super.key, required this.onRegister});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController(),
      phone = TextEditingController(),
      age = TextEditingController(),
      city = TextEditingController();
  String group = 'O+';
  bool available = true;
  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    age.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
      title: 'Become a donor',
      subtitle: 'Register your details to help someone in need.',
      child: CardSurface(
          child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Donor information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),
                    TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                            labelText: 'Full name',
                            prefixIcon: Icon(Icons.person_outline)),
                        validator: (v) => v == null || v.trim().length < 2
                            ? 'Enter your name'
                            : null),
                    const SizedBox(height: 13),
                    TextFormField(
                        controller: age,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Age',
                            prefixIcon: Icon(Icons.cake_outlined)),
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          return n == null || n < 18 || n > 65
                              ? 'Enter an age between 18 and 65'
                              : null;
                        }),
                    const SizedBox(height: 13),
                    TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: const InputDecoration(
                            labelText: '10-digit phone number',
                            prefixIcon: Icon(Icons.phone_outlined)),
                        validator: (v) =>
                            v == null || !RegExp(r'^\d{10}$').hasMatch(v)
                                ? 'Enter a valid 10-digit number'
                                : null),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                        value: group,
                        decoration: const InputDecoration(
                            labelText: 'Blood group',
                            prefixIcon: Icon(Icons.bloodtype_outlined)),
                        items: bloodGroups
                            .skip(1)
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) => setState(() => group = v ?? 'O+')),
                    const SizedBox(height: 13),
                    TextFormField(
                        controller: city,
                        decoration: const InputDecoration(
                            labelText: 'City / Location',
                            prefixIcon: Icon(Icons.location_on_outlined)),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Enter your location'
                            : null),
                    const SizedBox(height: 8),
                    SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: primaryRed,
                        title: const Text('Available to donate'),
                        value: available,
                        onChanged: (v) => setState(() => available = v)),
                    const SizedBox(height: 12),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                                backgroundColor: primaryRed,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15)),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                widget.onRegister(Donor(
                                    name: name.text.trim(),
                                    age: int.parse(age.text),
                                    phone: phone.text.trim(),
                                    blood: group,
                                    city: city.text.trim(),
                                    available: available));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Your donor profile has been added to the directory.')));
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Register as donor'))),
                    const SizedBox(height: 12),
                    const Text(
                        'Your donor details are added to this device’s donor directory. Keep your contact information accurate and update your availability when it changes.',
                        style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ]))));
}

class RequestsPage extends StatelessWidget {
  final List<BloodRequest> requests;
  final ValueChanged<BloodRequest> onAdd;
  const RequestsPage({super.key, required this.requests, required this.onAdd});
  @override
  Widget build(BuildContext context) => PageFrame(
      title: 'Blood requests',
      subtitle: 'Create and manage blood requirements in your community.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => showDialog(
                    context: context,
                    builder: (_) => RequestDialog(onSubmit: (r) {
                          onAdd(r);
                          Navigator.pop(context);
                        })),
                icon: const Icon(Icons.add),
                label: const Text('Create blood request'))),
        const SizedBox(height: 18),
        if (requests.isEmpty)
          const EmptyState(
              icon: Icons.volunteer_activism_outlined,
              title: 'No requests yet',
              detail: 'New blood requests you create will appear here.'),
        ...requests.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(
                    backgroundColor: paleRed,
                    child: Text(r.blood,
                        style: const TextStyle(
                            color: primaryRed, fontWeight: FontWeight.bold))),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(r.patient,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                const Chip(label: Text('Open'), backgroundColor: paleRed)
              ]),
              const SizedBox(height: 10),
              Text('${r.units} unit(s) of ${r.blood} required'),
              Text('Hospital: ${r.hospital}'),
              Text('Location: ${r.city}'),
              Text('Contact: ${r.phone}'),
              const SizedBox(height: 5),
              Text(
                  'Created: ${r.created.toLocal().toString().substring(0, 16)}',
                  style: const TextStyle(color: Colors.black45, fontSize: 11))
            ]))),
      ]));
}

class RequestDialog extends StatefulWidget {
  final ValueChanged<BloodRequest> onSubmit;
  const RequestDialog({super.key, required this.onSubmit});
  @override
  State<RequestDialog> createState() => _RequestDialogState();
}

class _RequestDialogState extends State<RequestDialog> {
  final keyForm = GlobalKey<FormState>();
  final patient = TextEditingController(),
      hospital = TextEditingController(),
      city = TextEditingController(),
      phone = TextEditingController(),
      units = TextEditingController(text: '1');
  String blood = 'O+';
  @override
  void dispose() {
    patient.dispose();
    hospital.dispose();
    city.dispose();
    phone.dispose();
    units.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
          title: const Text('New blood request'),
          content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                  child: Form(
                      key: keyForm,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                            controller: patient,
                            decoration: const InputDecoration(
                                labelText: 'Patient name'),
                            validator: requiredText),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                            value: blood,
                            decoration:
                                const InputDecoration(labelText: 'Blood group'),
                            items: bloodGroups
                                .skip(1)
                                .map((g) =>
                                    DropdownMenuItem(value: g, child: Text(g)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => blood = v ?? 'O+')),
                        const SizedBox(height: 10),
                        TextFormField(
                            controller: units,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Units required'),
                            validator: (v) => int.tryParse(v ?? '') == null ||
                                    int.parse(v!) < 1
                                ? 'Enter valid units'
                                : null),
                        const SizedBox(height: 10),
                        TextFormField(
                            controller: hospital,
                            decoration: const InputDecoration(
                                labelText: 'Hospital name'),
                            validator: requiredText),
                        const SizedBox(height: 10),
                        TextFormField(
                            controller: city,
                            decoration: const InputDecoration(
                                labelText: 'City / Location'),
                            validator: requiredText),
                        const SizedBox(height: 10),
                        TextFormField(
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                labelText: 'Contact number'),
                            validator: (v) =>
                                v == null || !RegExp(r'^\d{10}$').hasMatch(v)
                                    ? 'Enter 10-digit phone number'
                                    : null),
                      ])))),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            FilledButton(
                style: FilledButton.styleFrom(backgroundColor: primaryRed),
                onPressed: () {
                  if (keyForm.currentState!.validate())
                    widget.onSubmit(BloodRequest(
                        patient: patient.text.trim(),
                        blood: blood,
                        units: units.text,
                        hospital: hospital.text.trim(),
                        city: city.text.trim(),
                        phone: phone.text.trim(),
                        created: DateTime.now()));
                },
                child: const Text('Submit'))
          ]);
}

String? requiredText(String? v) =>
    v == null || v.trim().isEmpty ? 'This field is required' : null;

class ProfilePage extends StatefulWidget {
  final String userName, city;
  final int donorCount, requestCount;
  final Function(String, String) onSave;
  const ProfilePage(
      {super.key,
      required this.userName,
      required this.city,
      required this.donorCount,
      required this.requestCount,
      required this.onSave});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController name, city;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.userName);
    city = TextEditingController(text: widget.city);
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userName != widget.userName) name.text = widget.userName;
    if (oldWidget.city != widget.city) city.text = widget.city;
  }

  @override
  void dispose() {
    name.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
      title: 'My profile',
      subtitle: 'Keep your contact and location details up to date.',
      child: CardSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
            child: CircleAvatar(
                radius: 42,
                backgroundColor: paleRed,
                child: const Icon(Icons.person, size: 45, color: primaryRed))),
        const SizedBox(height: 15),
        const Center(
            child: Text('Your profile',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        const SizedBox(height: 22),
        TextField(
            controller: name,
            decoration: const InputDecoration(
                labelText: 'Display name',
                prefixIcon: Icon(Icons.person_outline))),
        const SizedBox(height: 14),
        TextField(
            controller: city,
            decoration: const InputDecoration(
                labelText: 'Your city',
                prefixIcon: Icon(Icons.location_on_outlined))),
        const SizedBox(height: 16),
        SizedBox(
            width: double.infinity,
            child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  if (name.text.trim().isEmpty || city.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill both fields')));
                    return;
                  }
                  widget.onSave(name.text.trim(), city.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated')));
                },
                child: const Text('Save profile'))),
        const Divider(height: 32),
        Text('Donor records on this device: ${widget.donorCount}'),
        const SizedBox(height: 8),
        Text('Requests created: ${widget.requestCount}'),
        const SizedBox(height: 18),
        const Text('About this application',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text(
            'Blood Connect helps people find blood donors by blood group and location, register as donors, and share blood requirements. The app provides a directory and communication aid; it does not verify medical eligibility or guarantee donor availability. Contact a licensed blood bank or healthcare professional for confirmation.'),
        const SizedBox(height: 12),
        const Text(
            'Information entered in this version stays on this device during the current app session. Online donor discovery and emergency coordination require a connected service. Always confirm availability with a licensed blood bank.',
            style: TextStyle(color: primaryRed, fontSize: 12))
      ])));
}

class CardSurface extends StatelessWidget {
  final Widget child;
  const CardSurface({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: child);
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, detail;
  const EmptyState(
      {super.key,
      required this.icon,
      required this.title,
      required this.detail});
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 20),
      child: Column(children: [
        Icon(icon, size: 48, color: Colors.black26),
        const SizedBox(height: 12),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 5),
        Text(detail,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54))
      ]));
}
