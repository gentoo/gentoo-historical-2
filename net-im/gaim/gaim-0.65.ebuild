# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gaim/gaim-0.65.ebuild,v 1.1 2003/07/17 14:51:16 lostlogic Exp $

IUSE="nls perl spell nas ssl"

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="http://gaim.sourceforge.net/"
EV=2.00
SRC_URI="mirror://sourceforge/gaim/${P}.tar.bz2
        ssl? ( mirror://sourceforge/gaim-encryption/encrypt-${EV}.tar.gz )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND="=sys-libs/db-1*
	>=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	nas? ( >=media-libs/nas-1.4.1-r1 )
	nls? ( sys-devel/gettext )
	media-libs/libao
	>=media-libs/audiofile-0.2.0
	perl? ( >=dev-lang/perl-5.6.1 )
	ssl? ( dev-libs/nss )
	spell? ( >=app-text/gtkspell-2.0.2 )"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${P}
	use ssl && {
		cd ${S}/plugins
		unpack encrypt-${EV}.tar.gz
		cd encrypt
		patch -p0 -l < ${FILESDIR}/patchfile.${PV} || die "Encryption patch failed"
	}
}

src_compile() {

	local myconf
        use perl || myconf="${myconf} --disable-perl"
        use spell || myconf="${myconf} --disable-gtkspell"
        use nls  || myconf="${myconf} --disable-nls"
	use nas && myconf="${myconf} --enable-nas" || myconf="${myconf} --disable-nas"

	econf ${myconf} || die "Configuration failed"
	emake || die "Make failed"
}

src_install() {
	einstall || die "Install failed"
	dodoc ABOUT-NLS AUTHORS HACKING INSTALL NEWS README TODO ChangeLog
}

pkg_postinst() {
	if [ `use ssl` ]; then
		ewarn
		ewarn "You have chosen (by selecting 'USE=ssl') to install"
		ewarn "the gaim-encryption plugin ( http://gaim-encryption.sf.net/ )"
		ewarn "this plugin is NOT supported by the Gaim project, and if you"
		ewarn "expierence problems related to it, contact the Gentoo project"
		ewarn "via http://bugs.gentoo.org/ or the gaim-encryption project."
		ewarn
	fi
}
