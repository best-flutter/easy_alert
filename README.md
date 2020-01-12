
<p align="center">
    <a href="https://pub.dartlang.org/packages/easy_alert">
        <img src="https://img.shields.io/pub/v/easy_alert.svg" alt="pub package" />
    </a>
</p>

# easy_alert

A package for flutter to use alert and toast within one line code.

## Getting Started

Add 

```
    easy_alert:
```

to your pubspec.yaml, and run `flutter packages get` in your project root directory.


## Showcases

![](https://github.com/jzoom/images/raw/master/toast.gif)
![](https://github.com/jzoom/images/raw/master/alert.gif)


## ROADMAP

* [x] alert
* [x] ios style alert
* [x] confirm
* [x] ios style confirm
* [x] toast
* [ ] customize alert dialog
* [ ] customize toast
* [ ] support bottom sheet.
* [x] support input
* [x] support pick and select

##  Integrate with your flutter app

```
void main() => runApp(new AlertProvider(
      child: new YourApp(),
      config: new AlertConfig(
        ok: "OK text for `ok` button in AlertDialog", 
        cancel: "CANCEL text for `cancel` button in AlertDialog"),
    ));
```




## alert

```
  Alert.alert(context, title: "Hello", content: "this is a alert")
      .then((_) => Alert.toast(context, "You just click ok"));

```

## confirm

```
 Alert.confirm(context, title: "Hello", content: "this is a alert")
          .then((int ret) =>
              Alert.toast(context, ret == Alert.OK ? "ok" : "cancel"));
```

## toast

```
Alert.toast(context,"Very long toast",position: ToastPosition.bottom, duration: ToastDuration.long);
```


## pick

```
try {
  int index = await Alert.pick(context,
      values: widget.values, index: widget.index);
    ...have selected
} catch (e) {
    ... cancel select
}
```


```


try {
    String ret = await Alert.select(context,
        options: [
          Option('A', 'a'),
          Option('B', 'b'),
          Option('C', 'c'),
        ],
        value: 'a');
Alert.toast(context, "You just pick $ret");
} catch (e) {
Alert.toast(context, "Canceled",
    position: ToastPosition.center);
}
```
