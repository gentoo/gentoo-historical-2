# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailwrapper/mailwrapper-0.1.ebuild,v 1.10 2004/04/01 19:20:15 randy Exp $

DESCRIPTION="Program to invoke an appropriate MTA based on a config file"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tbz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~sparc ~mips ppc ~alpha ~amd64 ~hppa ia64 ppc64 s390"
IUSE=""
DEPEND=""
S=${WORKDIR}/${P}

src_compile() {
	${CC:-gcc} ${CFLAGS} -o mailwrapper mailwrapper.c fparseln.c fgetln.c \
		|| die "gcc failed"
}

src_install() {
	newsbin mailwrapper sendmail || die "mailwrapper binary not installed"
	doman mailer.conf.5 mailwrapper.8
	dodir /etc
	insinto /etc
	doins mailer.conf || die "mailer.conf not installed"
}
