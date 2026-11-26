# iOS Advanced: Lightning Talks

Every team picked one Apple framework. In Session 5, each team shows it to the others:

- **~7 minute talk**: what the framework does, when to use it, what was hard
- **Short demo**: a small app that shows the framework in action

This repo collects all demos and slides in one place, so everyone can look them up later.
It counts **20% of your grade** (lightning talk + demo).

**Deadline:** open your pull request by the **evening before Session 5**.

---

## What you hand in

One folder per team, named after your framework:

```
teams/
└── swiftdata/            ← your folder (lowercase, dashes: e.g. foundation-models)
    ├── README.md         ← fill in the template
    ├── slides.pdf        ← your slides as PDF (not Keynote or PowerPoint)
    └── Demo/             ← your Xcode project
```

## How to hand it in (step by step)

Only **one person per team** has to do this.

**1. Fork this repo**
Click **Fork** (top right on GitHub). You now have your own copy.

**2. Clone your fork**

```bash
git clone git@github.com:<your-username>/ios-advanced-lightning-talks.git
cd ios-advanced-lightning-talks
```

**3. Create your team folder from the template**

```bash
cp -R TEMPLATE teams/swiftdata     # use your framework name
```

**4. Add your files**

- Put your Xcode project into `teams/swiftdata/Demo/`
- Export your slides as PDF to `teams/swiftdata/slides.pdf`
- Fill in `teams/swiftdata/README.md`

**5. Commit and push**

```bash
git checkout -b swiftdata
git add teams/swiftdata
git commit -m "Add SwiftData lightning talk"
git push -u origin swiftdata
```

**6. Open a pull request**
GitHub shows a **Compare & pull request** button on your fork. Click it, check the list in the description and create the pull request.

An automatic check then looks at your folder. If it is red, click **Details** to see what is missing, fix it and push again. The pull request updates by itself.

## Rules

1. **Only change your own folder** in `teams/`. Do not touch other files.
2. **The demo must build right away**: open the project, press Run. Only use Swift Package Manager for dependencies.
3. **No secrets**: no API keys, passwords or `GoogleService-Info.plist` in the repo. If you need a key, explain in your README where to put it.
4. **Slides as PDF**, so everyone can open them.
5. **Keep it small**: no files bigger than 50 MB. Videos go on YouTube or similar, link them in your README.

## Questions?

Ask in class, or open an issue in this repo.
