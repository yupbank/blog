## Matrix Factorization in recommendation


I am really confused about matrix factorization. 
As many turtotial explain the key idea about how this model works. And what kind of tricks inside factotization.
But when i decided to implement them, troubles come.
A clear idea between a few commonly used factorization models from a implementation perspective.

It's already been proved that matrix factorization is the best single model in prediction. As a new bee in recommendation, I think people like me should understand this model in every details.
Since my cretiria about understanding is being able to implement. Clearly, just key idea can not fulfill my needs.

So I have prepared my own study upon these models: SVD?, SVD++, SVD Feature and Factorization Machine. I am going to show you what's the same and different in between those models.


###First of all, the model equations of above models are being listed:

####1),  SVD or NMF: 

$$$R = U * \sigma * I $$$ or $$$ U*I $$$?

Commonly used (matrix factorization) MF in recommendation are mostly modeling the raint matrix as $$$R = U*I$$$.

But SVD is actually $$$ R = U* \sigma * I $$$.

But why people referring to the first one as SVD? A few papers are addressing this because of high portion of missing values caused by sparseness in the user-item ratings matrix. 

And more over carelessly addressing only the relatively few known entries is highly prone to overfitting. Thus, the most basic factorization model are being proposed as $$$R = U*I$$$. 

So the main idea is realted to SVD, but as sparsity, simplified version are broadly used.

Due to the over fitting probelm, so models in factorization employed objective function. Which has nothing to do with prediction directly, but to appoximate the parameter in a way we want, which in return do prediction.

Also basic MF has this type of objective function: $$ argmin \sum{(\hat{R} - R)}^2 + \lambda*|\theta|_2^2 $$
here $$$\theta$$$ denotes the set of pramaters which is U and I. And $$$\lambda$$$ denotes how much the regularization effects the approximation.
Some recently basic, which is not state of art have bais term. 

$$ \hat{R} = bias + U*I $$

And the objective function are still the same.

####2), SVD++:

$$ \hat{R} =  Bias + (U+|feedback(U)|^{-1/2} \sum_{i \in feedback(u)} y_i)*I $$

####3), SVD feature:

$$ \hat{R} = bias+(\sum_{g \in G} {\gamma_g bias_g}+ \sum\_{m \in M} {\alpha_m bias_m}+ \sum\_{n \in N} {\beta_n bias_n} ) \
+(\sum\_{m \in M} {\alpha_m U_m})^T * (\sum\_{n \in N} {\beta_n I_n})
$$

####4), Factorization machine:

$$\hat{R} = w_0 + \sum_{j=1}^{P} {w_j x_j}+\
1/2*\sum\_{f=1}^{K} [(\sum\_{j=1}^{P} {v\_{j,f} x_j})^2-\sum\_{j=1}{P} {v\_{jf}^2 x\_j^2}] $$


###The second thing i care is input. 

How is input gonna perform different? Is it always are the instances? 
I think the most important thing is that is features involved. Apperantly, from the equation, we can tell the SVD model has no room for extra features.
While, SVD++, SVD feature and Factorization machine can employ both explicit and implicit features.
Thus, implicit.



