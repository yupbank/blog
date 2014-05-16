## Matrix Factorization in recommendation

## Recent studies in this area.

I am really confused about matrix factorization actually. As many turtotial explain the key idea about how this model works. And what kind of tricks inside factotization.
I still dont have a clear idea between a few commonly used factorization models from a implementation perspective.

It's already been proved that matrix factorization is the best single model in prediction. As a new bee in recommendation, I think people like me should understand this model in every details.
Since my cretiria about understanding is being able to implement. Clearly, just key idea can not fulfill my needs.

So I have prepared my own study upon these models: SVD?, SVD++, SVD Feature and Factorization Machine. I am going to show you what's the same and different in between those models.
First of all, the model equation of above models are being listed:

SVD: R = U*\sigma*I or R = U*I ?

Commonly used MF in recommendation are mostly modeling the raint matrix as R = U*I
Why is this to do with SVD? A few papers are referring this as high portion of missing values caused by sparsenewss in the user-item ratings matrix. And more over carelessly addressing only the relatively few known entries is highly prone to overfitting. Thus, the most basic factorization model are being proposed as R = U*I. 
So the main idea is realted to SVD, but as sparsity, simplified version are broadly used.
While SVD is R = U*\sigma*I still. Many blogs talking about matrix factorization and svd referred to are not truly svd but a simplification

As metioned above the over fitting probelm, so models in factorization employed objective function. Which has nothing to do with prediction directly, but to appoximate the parameter which do prediction.

Also basic mf has this type of objective function: argmin \sum{(\hat{R} - R)}^2 + \lambda*|\theta|_2
here \theta denotes the set of pramaters which is U and I. And \lambda denotes how much the regularization effects the approximation.
Some recently basic, which is not state of art have bais term. 

R = bias + U*I 

This only effect model but has nothing directly to do with objective function

SVD++:

R =  Bias + (U+\sum{\beta*y_i}_{i \in feedback(u)})*I

SVD feature:

R = \sum{\alpha*global_bias} + \sum{\beta*user_bias} + \sum{\zeta*item_bias} + (\sum{U*\beta})*(\sum{\zeta*item_bias})

Factorization machine:

R = bias + \feature

Second thing i care is input. 

How is input gonna perform different? As it always be the instance? 



