# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/freewnn/freewnn-1.1.1_alpha17.ebuild,v 1.8 2005/01/01 14:28:03 eradicator Exp $

inherit eutils

MY_P="FreeWnn-${PV/_alpha/-a0}"

DESCRIPTION="Network-Extensible Kana-to-Kanji Conversion System"
HOMEPAGE="http://www.freewnn.org/"
SRC_URI="ftp://ftp.freewnn.org/pub/FreeWnn/alpha/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64 ~ia64"
IUSE="X ipv6"

DEPEND="virtual/libc
	X? ( virtual/x11 )"

S="${WORKDIR}/${MY_P}/Xsi"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/a017/FreeWnn-sighandler.patch
	epatch ${FILESDIR}/a017/FreeWnn-uum.patch
	epatch ${FILESDIR}/a017/FreeWnn-1.1.1-a017.dif
	#epatch ${FILESDIR}/a017/FreeWnn-lib64.patch
	use s390 && epatch ${FILESDIR}/a017/FreeWnn-s390x.patch

	#Change WNNOWNER to root so we don't need to add wnn user
	sed -i -e "s/WNNOWNER = wnn/WNNOWNER = root/" ${S}/makerule.mk.in
}

src_compile() {
	econf \
		--disable-cWnn \
		--disable-kWnn \
		--without-termcap \
		`use_with X x` \
		`use_with ipv6` || die "./configure failed"

	emake || die
	#make || die
}

src_install() {
	# install executables, libs ,dictionaries
	make DESTDIR=${D} install || die "installation failed"
	# install man pages
	make DESTDIR=${D} install.man || die "installation of manpages failed"
	# install docs
	dodoc ChangeLog* INSTALL* CONTRIBUTORS
	# install rc script
	exeinto /etc/init.d ; newexe ${FILESDIR}/freewnn.initd freewnn
}
