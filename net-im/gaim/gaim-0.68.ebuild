# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gaim/gaim-0.68.ebuild,v 1.2 2003/09/07 22:02:19 weeve Exp $

IUSE="nls perl spell nas ssl"

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="http://gaim.sourceforge.net/"
EV=2.10
SRC_URI="mirror://sourceforge/gaim/${P}.tar.bz2
		ssl? ( mirror://sourceforge/gaim-encryption/gaim-encryption-${EV}.tar.gz )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND="=sys-libs/db-1*
	>=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	nas? ( >=media-libs/nas-1.4.1-r1 )
	sys-devel/gettext
	media-libs/libao
	>=media-libs/audiofile-0.2.0
	perl? ( >=dev-lang/perl-5.6.1
		>=sys-apps/sed-4.0.0 )
	ssl? ( dev-libs/nss )
	spell? ( >=app-text/gtkspell-2.0.2 )"

src_unpack() {
	unpack ${P}.tar.bz2
	use ssl && {
		cd ${S}/plugins
		unpack gaim-encryption-${EV}.tar.gz
	}
	#use cjk && {
		#cd ${S}/src
		#epatch ${FILESDIR}/gaim_gtkimcontext_patch.diff
	#}
}

src_compile() {

	local myconf
	use perl || myconf="${myconf} --disable-perl"
	use spell || myconf="${myconf} --disable-gtkspell"
	use nls  || myconf="${myconf} --disable-nls"
	use nas && myconf="${myconf} --enable-nas" || myconf="${myconf} --disable-nas"

	econf ${myconf} || die "Configuration failed"
	emake || MAKEOPTS="${MAKEOPTS} -j1" emake || die "Make failed"

	use ssl && {
		cd ${S}/plugins/gaim-encryption-${EV}
		econf || die "Configuration failed for encryption"
		emake || die "Make failed for encryption"
	}
}

src_install() {
	use perl && sed -i -e 's:\(-e "install(\)\(.@ARGV.,.$(VERBINST).,0,.$(UNINST).);"\):\1$(DESTDIR)/\2:' plugins/perl/common/Makefile
	einstall || die "Install failed"
	use ssl && {
		cd ${S}/plugins/gaim-encryption-${EV}
		einstall || die "Install failed for encryption"
		cd ${S}
	}
	dodoc ABOUT-NLS AUTHORS COPYING HACKING INSTALL NEWS PROGRAMMING_NOTES README ChangeLog VERSION
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
