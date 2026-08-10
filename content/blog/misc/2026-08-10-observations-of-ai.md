---
layout: post
title: Observations from three years of AI
tags: ["misc"]
categories: misc
description: "Observations, experiences, and the effect of AI on society. Should the business exist?"
date: 2026-08-10
draft: true
---

<!--TODO: REMOVE DRAFT FLAG-->

Three years ago I wrote [My thoughts on AI code generators]({{<
ref "2023-08-02-ai-licensed-code.md" >}}) just as AI coding was taking
off. AI has improved immensely since then.

My journey in the tech realm really began with my degree in Computer Science,
starting in 2018. I don't know how the AI landscape looked before that, but as I
did my degree, AI was hyped up everywhere. Everyone wanted to learn AI and
machine learning. The university even started creating an AI degree (which I
believe was launched the term after I left in 2021). Large Language Models (LLM)
as we know today didn't exist yet, but every CS student wanted to learn about
AI. Initially, I too viewed AI as cool and interesting.

Over time, the glamorous world of AI started to fade in my eyes. I took an
AI course and then did my Bachelor's thesis on it. I realized it wasn't nearly
as fun as everyone made it out to be. Tweaking parameters to get slightly better
results and then waiting for the Neural Network (NN) to train. I should clarify,
my main gripe was with NN. I loved and still do love algorithmic AI based on
heuristics, for example game theory and alpha-beta pruning. Unfortunately, that
is greatly overshadowed by NN and LLMs today. 

All this is to say that I was tired of AI before LLMs even existed. When the
news of LLMs came I was always sceptical to its practical use.


## Impact on work

### Rotting the brain

What happens when you stop using your brain? It rots. This is true for
the brain in general. Going months or years without doing a skill
inevitably dulls the skill; this is nothing new for AI. Getting back into
it usually isn't too difficult. The risk with AI is doing the task without using
the skill. Especially when the expectation is that you should know how to do it
and how it works. Speaking as a software developer, my job is to be an expert at
specific fields relevant for my employer. If I don't actively spend time
learning and debugging the application I won't have the necessary knowledge.
Becaus I have spent months and years working within the field, debugging at
every level, I have deep knowledge of it. I can answer a lot of questions off the
top of my head. Sometimes, AI cannot even answer these questions because they are
rather niche and the answer may come entirely from experience, with no true
source being written down anywhere.

I am afraid handing over my entire daily work to AI will result in me developing
a lot of code that I have little understanding of. The better the AI is, the
less time I will have spent working on the code. If it got everything right on
the first try I would only have to review the code and test the
feature (which is fun until something breaks). After a while I would lose the
sense of the details because I never touch those parts anymore. Eventually, I'll
have moved up an abstraction level and am now a manager or product owner, with
no human below me.

Personal development is heavily inhibited by AI. Outsourcing thinking means
never having to think for myself. There is no opportunity to get better at the
things I do. The things I love. Leading to over-reliance on AI. Even boring
tasks are good to know how they work. Lifelong learning is a big part of who I
am.


### Pressure from management

At my job management were early to jump on the AI bandwagon. Our CEO decided that we
need to be on the forefront of AI. We'll get left behind if we don't.
Microsoft already runs our entire IT infrastructure so getting their Copilot for
everyone was the first step. Some employees have gotten to demonstrate how they
use AI so others can learn. They have brought in external consultants to teach
us how to better use AI. I always stayed on the sidelines just watching, trying
it occasionally. It's not useless but I'm still not entirely sold on it. Every
management presentation mentions AI. They scheduled bi-weekly (optional)
meetings for knowledge sharing. AI was always optional, but it was omnipresent.

GitHub Copilot has also been a large part of the AI rollout. Which is primarily
what affects me as a developer.

My breaking point came when it was no longer optional. During the annual
performance review I had AI put into my goals for the next year and felt like I
had no say in it. Later in the year there was an optional seminar with an AI
consultant. I didn't feel it was optional. I was "strongly recommended" to
attend it due to my "goals" of using more AI.

No matter how arduous or mind-numbing a work-related task is I will happily do
it. But I went to that seminar with resentment and no intention to learn, and
walked out of it the same way. Pressure is not a good motivator.


### Pressure from Microsoft and AI generated messages

Every day when I open Teams it wants me to pin Copilot to the sidebar. The only
options are "Pin" or "Maybe Later". Teams is already damn slow as it is (on
Linux at least). I have tried pinning it, but if I then unpin it I start getting
the notifications again. I use Copilot occasionally, but when I do I go to the
website `copilot.cloud.microsoft`.

The pin requests stopped after some number of weeks. But Microsofts insistence
on Copilot mentally hurts. Sometimes it almost feels like they treat you like a
child. "Hey, you can use a Copilot to write an email if you need some help".
Thanks, but I am fully capable of writing an email myself as I have done for
many years. I have received AI messages myself. It's not fun when you put effort
into a conversation, only for the other end to give a generic AI reply. My worst
experience was a support case I had with a supplier. I gave a long detailed
explanation of the bug, everything I had tried, and pointing to what I believe
the issue was. Only for them to a few days later send a fully AI generated
response, of which about 95% was asking about things my initially message
already covered, either because I'd already disproven it, or it was not relevant
to my use case.


### Human conversation and knowledge sharing

After the COVID-19 pandemic, many companies wanted employees to return to office
under the guise of teamwork and collaboration. While work-from-home is nice, I
do agree with that sentiment (but a few days from home here and there doesn't
hurt). Being in the office opens up for more natural conversations between
people. Conversations that might not happen otherwise. And it builds social
connections.

With AI capable of answering most questions, what reason is there to talk
to our colleagues in our day-to-day work? Our colleagues will be out of the loop
more than ever. Knowledge silos become more prevalent. Or are silos perhaps less
of a problem because now the AI sits on all the knowledge, and all context is
lost when the chat slowly fades further and further back in your Copilot
history, never to be seen again?

Talk to your colleagues! Everyone has unique knowledge and experience to share.


## AI elsewhere in life

### Misinformation and slop

No LLM will ever be perfect. Neither will humans, but good search algorithms
tend to filter out the slop. Trusted sources are presented at the top (though,
recently even this is questionable as Google search itself has arguably become worse).
We can look through the sources, learn things and get some context for the information.

AI is built on convenience, something everyone wants. One of the worst offenders
is Google AI overview. Always there at the top, providing a quick answer to your
question. No need to look further, assuming you trust the AI. Google AI
summaries have been [shown again and again to give troublesome
information](https://www.theguardian.com/technology/2026/jan/02/google-ai-overviews-risk-harm-misleading-health-information).
The internet already had a problem of misinformation, AI only amplifies it many
times over. This is another case of rotting the brain. When a confident answer
is readily available it is very easy to trust it.

To get rid of the AI overview I recommend using alternative search engines.
DuckDuckGo allows turning off their AI overview. They also offer a search with
[no AI features whatsoever](https://noai.duckduckgo.com/).

Unfortunately, this doesn't stop all the slop generated on various websites.


### Art, film, and music

I'm very much against AI art in general. There are many arguments against it in
terms of copyright and how it hurts artists.

Images and film can still be somewhat distinguished from human-made (but not
always). I think there's also a difference in how the art is appreciated, for me
at least. When appreciating visual media I look at the details of it. Visual
media tends to be connected to some message. E.g. advertisements. Coca Cola
famously made an AI commercial
([2024](https://www.youtube.com/watch?v=E3-J0MwvBSI),
[2025](https://www.youtube.com/watch?v=dwex5VgfQtw)). Seeing that invokes the
"feeling of slop", as if someone wasn't bothered to use real art. If something
posted online is clearly AI then it's almost automatic that I won't "appreciate
the art" in the same sense as I would a really good human-made painting. If I
know something is human-made it's easier to appreciate the work put into it.
This sentiment has also been seen in the game industry. Gamers can't appreciate
the game to the same level when parts of it are AI-made.

AI generated music, however, has given me a different impression. Maybe because
my journey with it didn't start out hearing all the slop first. Or maybe because
I appreciate music differently. For me it started with the song [A Feeling We
Can't Hide - Lyra Vesperi](https://www.youtube.com/watch?v=7fKdyM4pknc), which
at the time I didn't know was AI generated. I liked the song. As I discovered
the artist used AI for the music I wasn't immediately taken aback. After some
reflection I decided I still appreciated the music. I'm by no means a music
expert. If I like the sound I will dance along to it. But I won't actively seek
out AI music to listen to.


### Cost of AI

Money has always been a question surrounding LLMs. People are "tokenmaxxing",
trying to utilize their tokens in the most efficient way possible. All while AI
companies are still wildly unprofitable. Everyone is betting on it becoming
profitable one day. The bubble is growing and I expect it to one day burst. Ask
yourself: "Do I want to be fully reliant on AI when the costs skyrocket?".

The cost isn't entirely monetary either. The datacenters running all of this has
taken a significant toll on their surrounding areas, water and noise pollution,
and a big jump in electricity cost for the population.

My post in 2023 focused only on AI code generators and their legality. Today
there has been many court cases. However, the question of AI training material
still hasn't been resolved in any court. OpenAI has openly admitted that they
wouldn't be able to make LLMs if they didn't use copyrighted material.

> Because copyright today covers virtually every sort of human
> expression -- including blog posts, photographs, forum posts, scraps
> of software code, and government documents -- it would be impossible
> to train today's leading AI models without using copyrighted materials.
> --- [The Guardian](https://www.theguardian.com/technology/2024/jan/08/ai-tools-chatgpt-copyrighted-material-openai)

OpenAI originally set out to develop AI responsibly due to fears of how it could
negatively affect the world if handled irresponsibly. Today, AI is rotting our
brains, spreading misinformation, ruining art, building a potential economic
bubble, destroying the land, and all this by possibly breaching copyright law.
It touches every corner of society. All in the name of chasing profits.

To quote a [Calvin and Habs sketch on YouTube](https://www.youtube.com/shorts/rEQhA-JJlH0):

> THEN THE BUSINESS SHOULD NOT EXIST!
