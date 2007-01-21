# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mailx/mailx-8.1.2.20050715-r1.ebuild,v 1.5 2007/01/21 13:33:45 eroyf Exp $

inherit ccc eutils flag-o-matic

IUSE=""
MX_MAJ_VER=${PV%.*}
MX_MIN_VER=${PV##*.}
MY_PV=${MX_MAJ_VER}-0.${MX_MIN_VER}cvs
S=${WORKDIR}/${PN}-${MY_PV}.orig/
debian_patch=${PN}_${MY_PV}-1.diff.gz

DESCRIPTION="The /bin/mail program, which is used to send mail via shell scripts."
SRC_URI="mirror://gentoo/mailx_${MY_PV}.orig.tar.gz
	mirror://gentoo/${debian_patch}"
HOMEPAGE="http://www.debian.org"

DEPEND=">=net-libs/liblockfile-1.03
	virtual/mta
	!mail-client/mailutils
	mail-client/mailx-support
	!virtual/mailx"
PROVIDE="virtual/mailx"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm hppa ia64 mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${DISTDIR}/${debian_patch}"
	epatch "${FILESDIR}/${P}-nostrip.patch"
	sed -i -e "s: -O2: \$(EXTRAFLAGS):g" Makefile
}

src_compile() {
	is-ccc && replace-cc-hardcode
	make EXTRAFLAGS="${CFLAGS}" || die
}

src_install() {
	dodir /bin /usr/share/man/man1 /etc /usr/lib

	insinto /bin
	insopts -m 755
	doins mail

	doman mail.1

	dosym mail /bin/Mail
	dosym mail /bin/mailx
	dosym mail.1 /usr/share/man/man1/Mail.1

	cd ${S}/misc
	insinto /usr/share/${PN}/
	insopts -m 644
	doins mail.help mail.tildehelp
	insinto /etc
	insopts -m 644
	doins mail.rc
}
