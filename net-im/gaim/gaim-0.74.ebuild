# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gaim/gaim-0.74.ebuild,v 1.1 2003/11/26 16:56:28 rizzo Exp $

IUSE="nls perl spell nas ssl mozilla cjk"

DESCRIPTION="GTK Instant Messenger client"
HOMEPAGE="http://gaim.sourceforge.net/"
EV=2.18
SRC_URI="mirror://sourceforge/gaim/${P}.tar.bz2
	ssl? ( mirror://sourceforge/gaim-encryption/gaim-encryption-${EV}.tar.gz )"
RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~amd64"

DEPEND="=sys-libs/db-1*
	>=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	nas? ( >=media-libs/nas-1.4.1-r1 )
	sys-devel/gettext
	media-libs/libao
	>=media-libs/audiofile-0.2.0
	perl? ( >=dev-lang/perl-5.6.1
		>=sys-apps/sed-4.0.0 )
	mozilla? ( net-www/mozilla )
	!mozilla? ( dev-libs/nss )
	spell? ( >=app-text/gtkspell-2.0.2 )"

src_unpack() {
	unpack ${A} || die
	use cjk && epatch ${FILESDIR}/gaim-0.74_cjk_gtkconv.patch

	use ssl && {
		cd ${S}/plugins
		unpack gaim-encryption-${EV}.tar.gz
	}
}

src_compile() {

	local myconf
	use perl || myconf="${myconf} --disable-perl"
	use spell || myconf="${myconf} --disable-gtkspell"
	use nls  || myconf="${myconf} --disable-nls"
	use nas && myconf="${myconf} --enable-nas" || myconf="${myconf} --disable-nas"

	if [ `use mozilla` ]; then
		NSS_LIB=/usr/lib/mozilla
		NSS_INC=/usr/lib/mozilla/include
	else
		NSS_LIB=/usr/lib
		NSS_INC=/usr/include
	fi

	myconf="${myconf} --with-nspr-includes=${NSS_INC}/nspr"
	myconf="${myconf} --with-nss-includes=${NSS_INC}/nss"
	myconf="${myconf} --with-nspr-libs=${NSS_LIB}"
	myconf="${myconf} --with-nss-libs=${NSS_LIB}"

	econf ${myconf} || die "Configuration failed"
	use perl && sed -i -e 's:^\(PERL_MM_PARAMS =.*PREFIX=\)\(.*\):\1'${D}'\2:' plugins/perl/Makefile
	emake || MAKEOPTS="${MAKEOPTS} -j1" emake || die "Make failed"

	use ssl && {
		local myencconf
		cd ${S}/plugins/gaim-encryption-${EV}

		myencconf="${myencconf} --with-nspr-includes=${NSS_INC}/nspr"
		myencconf="${myencconf} --with-nss-includes=${NSS_INC}/nss"
		myencconf="${myencconf} --with-nspr-libs=${NSS_LIB}"
		myencconf="${myencconf} --with-nss-libs=${NSS_LIB}"
		econf ${myencconf} || die "Configuration failed for encryption"
		emake || die "Make failed for encryption"
	}
}

src_install() {
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
