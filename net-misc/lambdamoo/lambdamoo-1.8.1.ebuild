# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/lambdamoo/lambdamoo-1.8.1.ebuild,v 1.1 2003/07/11 15:08:36 vapier Exp $

DESCRIPTION="networked mud that can be used for different types of collaborative software"
HOMEPAGE="http://sourceforge.net/projects/lambdamoo/"
SRC_URI="mirror://sourceforge.net/lambdamoo/LambdaMOO-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"

DEPEND="sys-devel/bison"

S=${WORKDIR}/MOO-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	autoconf
}

src_compile() {
	econf || die
	emake CFLAGS="${CFLAGS} -DHAVE_MKFIFO=1" || die
}

src_install() {
	dosbin moo
	insinto /usr/share/${PN}
	doins Minimal.db
	dodoc *.txt README*

	exeinto /etc/init.d ; newexe ${FILESDIR}/lambdamoo.rc lambdamoo
        insinto /etc/conf.d ; newins ${FILESDIR}/lambdamoo.conf lambdamoo
}
