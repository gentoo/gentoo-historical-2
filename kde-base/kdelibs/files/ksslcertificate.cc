/* This file is part of the KDE project
 *
 * Copyright (C) 2000 George Staikos <staikos@kde.org>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "ksslcertificate.h"


class KSSLCertificatePrivate {
public:
  KSSLCertificatePrivate() {
  }

  ~KSSLCertificatePrivate() {
  }

  #ifdef HAVE_SSL
    X509 *m_cert;
  #endif
};

KSSLCertificate::KSSLCertificate() {
  d = new KSSLCertificatePrivate;
#ifdef HAVE_SSL
  d->m_cert = NULL;
#endif
}


KSSLCertificate::~KSSLCertificate() {
#ifdef HAVE_SSL
  if (d->m_cert)
    X509_free(d->m_cert);
#endif
  delete d;
}


QString KSSLCertificate::getSubject() const {
QString rc = "";

#ifdef HAVE_SSL
  char *t = X509_NAME_oneline(X509_get_subject_name(d->m_cert), 0, 0);
  if (!t) return rc;
  rc = t;
  CRYPTO_free(t);    // NOTE - _Free_  *NOT*  _free_
#endif

return rc;
}


QString KSSLCertificate::getIssuer() const {
QString rc = "";

#ifdef HAVE_SSL
  char *t = X509_NAME_oneline(X509_get_issuer_name(d->m_cert), 0, 0);
  if (!t) return rc;
  rc = t;
  CRYPTO_free(t);    // NOTE - _Free_  *NOT*  _free_
#endif

return rc;
}


#ifdef HAVE_SSL
void KSSLCertificate::setCert(X509 *c) {
  d->m_cert = c;
}
#endif

