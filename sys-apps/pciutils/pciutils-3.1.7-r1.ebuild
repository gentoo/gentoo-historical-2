# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pciutils/pciutils-3.1.7-r1.ebuild,v 1.2 2012/05/24 00:02:37 ssuominen Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Various utilities dealing with the PCI bus"
HOMEPAGE="http://mj.ucw.cz/sw/pciutils/ http://git.kernel.org/?p=utils/pciutils/pciutils.git"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="network-cron static-libs zlib"

DEPEND="zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	!sys-apps/hal"

src_prepare() {
	epatch "${FILESDIR}"/${P}-install-lib.patch #273489
	epatch "${FILESDIR}"/${P}-fbsd.patch #262321

	if use static-libs ; then
		cp -pPR "${S}" "${S}.static" || die
	fi
}

uyesno() { use $1 && echo yes || echo no ; }
pemake() {
	emake \
		HOST="${CHOST}" \
		CROSS_COMPILE="${CHOST}-" \
		CC="$(tc-getCC)" \
		DNS="yes" \
		IDSDIR="/usr/share/misc" \
		MANDIR="/usr/share/man" \
		PREFIX="/usr" \
		SHARED="yes" \
		STRIP="" \
		ZLIB=$(uyesno zlib) \
		LIBDIR="\${PREFIX}/$(get_libdir)" \
		"$@" || die
}

src_compile() {
	pemake OPT="${CFLAGS}" all
	if use static-libs ; then
		pemake \
			-C "${S}.static" \
			OPT="${CFLAGS}" \
			SHARED="no" \
			lib/libpci.a
	fi
}

src_install() {
	pemake DESTDIR="${D}" install install-lib || die
	use static-libs && { dolib.a "${S}.static/lib/libpci.a" || die ; }
	dodoc ChangeLog README TODO

	if use network-cron ; then
		exeinto /etc/cron.monthly
		newexe "${FILESDIR}"/pciutils.cron update-pciids \
			|| die "Failed to install update cronjob"
	fi

	newinitd "${FILESDIR}"/init.d-pciparm pciparm
	newconfd "${FILESDIR}"/conf.d-pciparm pciparm
}

pkg_postinst() {
	elog "The 'pcimodules' program has been replaced by 'lspci -k'"
}
