import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Чтобы создать новый экземпляр Firestore, вызовите instanceгеттер FirebaseFirestore:
FirebaseFirestore firestore = FirebaseFirestore.instance;

// Firestore с дополнительным приложением Firebase, используйте instanceForметод:
FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
FirebaseFirestore firestore2 = FirebaseFirestore.instanceFor(app: secondaryApp);

// Firestore хранит данные в «документах», которые содержатся в «коллекциях».
// Документы также могут содержать вложенные коллекции.
// Например, каждый из наших пользователей будет иметь свой собственный «документ», хранящийся в коллекции «Пользователи».
// Метод [collection] позволяет нам ссылаться на коллекцию в нашем коде.

// В приведенном ниже примере мы можем ссылаться на коллекцию usersи создавать новый пользовательский документ при нажатии кнопки:
class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      return users
          .add({'full_name': fullName, 'company': company, 'age': age})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: const Text(
        "Add User",
      ),
    );
  }
}

// Read Data
class GetUserName extends StatelessWidget {
  final String documentId;

  const GetUserName(this.documentId, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return const Text("loading");
      },
    );
  }
}

// Realtime changes with Stream
// StreamBuilder который помогает автоматически управлять состоянием потоков и удалением потока.
Stream collectionStream =
    FirebaseFirestore.instance.collection('users').snapshots();
Stream documentStream =
    FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['full_name']),
              subtitle: Text(data['company']),
            );
          }).toList(),
        );
      },
    );
  }
}


// При выполнении запроса Firestore возвращает либо  QuerySnapshot либо  DocumentSnapshot.

// A QuerySnapshotвозвращается из запроса коллекции и позволяет вам проверять коллекцию, например, 
// сколько документов существует в ней, дает доступ к документам в коллекции, просматривать любые изменения с момента последнего запроса и многое другое.
// Чтобы получить доступ к документам внутри QuerySnapshot, вызовите docsсвойство, которое возвращает Listсодержащие DocumentSnapshotклассы.

// FirebaseFirestore.instance
//     .collection('users')
//     .get()
//     .then((QuerySnapshot querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//             print(doc["first_name"]);
//         });
//     });

// A DocumentSnapshotвозвращается из запроса или при прямом доступе к документу.
// Чтобы определить, существует ли документ, используйте existsсвойство:
// FirebaseFirestore.instance
//     .collection('users')
//     .doc(userId)
//     .get()
//     .then((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         print('Document exists on the database');
//       }
//     });


// Если документ существует, вы можете прочитать данные о нем, вызвав data метод,
//  который возвращает Map<String, dynamic>, или, nullесли он не существует:

// FirebaseFirestore.instance
//     .collection('users')
//     .doc(userId)
//     .get()
//     .then((DocumentSnapshot documentSnapshot) {
//       if (documentSnapshot.exists) {
//         print('Document data: ${documentSnapshot.data()}');
//       } else {
//         print('Document does not exist on the database');
//       }
//     });


// A DocumentSnapshotтакже предоставляет возможность доступа к глубоко вложенным данным без ручной итерации возвращаемых Mapс помощью get метода. 
// Метод принимает разделенный точками путь или FieldPathэкземпляр. 
// Если во вложенном пути нет данных, a StateError:

// try {
//   dynamic nested = snapshot.get(FieldPath(['address', 'postcode']));
// } on StateError catch(e) {
//   print('No nested field exists!');
// }


// Фильтрация 
// Чтобы отфильтровать документы в коллекции, whereметод можно связать со ссылкой на коллекцию.
//  Фильтрация поддерживает проверки на равенство и "входящие" запросы. 
// Например, чтобы отфильтровать пользователей, возраст которых превышает 20 лет:

// FirebaseFirestore.instance
//   .collection('users')
//   .where('age', isGreaterThan: 20)
//   .get()
//   .then(...);