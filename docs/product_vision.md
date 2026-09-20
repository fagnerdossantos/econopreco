# Econopreço

![Version](https://img.shields.io/badge/version-v1.0.0--beta-blue?style=flat-square)
![Status](https://img.shields.io/badge/status-beta-orange?style=flat-square)

### What is Econopreço?

**Econopreço** is a grocery price comparison and aggregation platform tracking major supermarket chains across Rio de Janeiro, Brazil. Built around the daily routines and needs of local shoppers, it removes the hassle of digging through physical promotional flyers and scattered websites to find the best deals on everyday groceries.

---

### Where did the idea come from?

My daily life has always been a sprint between the gym, college, home, and work. There was virtually no time left to research where to buy groceries. Because grocery shopping is a frequent necessity, I found myself enduring an exhausting manual routine: checking one supermarket's website, downloading a PDF flyer for another that lacked an online store, and taking notes item by item in a notepad app to find out where the cheapest basket was.

In my neighborhood alone, there are more than three major supermarket chains, but comparing prices between them was a tedious chore. That’s when I thought: *"What if I automated this whole process and turned it into a simple mobile app?"*

After extensive research and testing to validate technical feasibility, my main dilemma became: *"Is this a real collective problem, or just mine?"* I spoke with friends and family about their grocery shopping habits (without revealing the app concept upfront) and confirmed that this frustration was shared by almost everyone. That is how Econopreço was born.

---

### What does Econopreço deliver to the user?

- **Direct Comparison:** Real-time, up-to-date pricing across major supermarket chains side by side.
- **Time & Money Savings:** Quickly discover where your daily shopping basket is cheapest before stepping out the door.
- **Transparency:** Centralized access to products, catalogs, and top discounts in a single place.

---

### Monitored Chains & Coverage

Econopreço initially focuses on the most prominent supermarket chains operating in Rio de Janeiro:

- **Supported Chains:** Guanabara, Mundial, Supermarket, Carrefour, Pão de Açúcar, Extra, and Super Prix.
- **Coverage Area:** Initially centered on the city of Rio de Janeiro and the Greater Rio metropolitan area, with an architecture designed to scale into more neighborhoods and regions over time.

---

### How it works behind the scenes

To deliver a fast, frictionless mobile experience, the Econopreço ecosystem operates across four continuous stages:

1. **Automated Ingestion:** A background service periodically monitors and extracts data from registered supermarket catalogs, gathering product names, prices, categories, and active deals.
2. **Intelligent Normalization:** Supermarkets register items with varying naming patterns, abbreviations, or codes. This stage cleans and matches data using string algorithms and fuzzy matching to ensure accurate, fair side-by-side comparison.
3. **Visual Processing:** The catalog downloads and optimizes official product imagery so browsing is fast, visual, and intuitive.
4. **Client Experience & Querying:** This unified dataset powers the final client application, enabling fast product searches, price lookups, favorite lists, and deal highlights.

---

### Future Roadmap

Econopreço was designed to be much more than an isolated item search tool. Upcoming features planned for future releases include:

- **Smart Cart Optimization:** Build your entire grocery list and discover where the overall total is lowest — or how to strategically split purchases between two nearby stores to maximize savings.
- **Deal Alerts:** Personalized notifications whenever your staple products (such as coffee, olive oil, meat, or diapers) go on sale.
- **Price History:** Track price trends to see whether a deal is genuinely discounted or has recently increased.
- **Continuous Expansion:** Incorporating wholesale stores (*atacarejos*), regional chains, and broader geographical coverage.

---

### Project Status

Econopreço is currently in its **Beta Release** phase.

This document accompanies the initial beta rollout for early testers. The primary goal of the Beta is to test real-world usability during daily grocery runs, collect user feedback, identify opportunities for improvement, and shape future milestones together with the community.
