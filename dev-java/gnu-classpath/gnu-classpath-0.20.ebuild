# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-classpath/gnu-classpath-0.20.ebuild,v 1.1 2006/01/22 05:53:57 nichoj Exp $

inherit eutils autotools

MY_P=${P/gnu-/}
DESCRIPTION="Free core class libraries for use with virtual machines and compilers for the Java programming language"
SRC_URI="ftp://ftp.gnu.org/gnu/classpath/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/classpath"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~x86 ~amd64"

# Add the doc use flag after the upstream build system is improved
# See their bug 24025

IUSE="alsa cairo debug dssi examples gtk xml2"

RDEPEND="alsa? ( media-libs/alsa-lib )
		dssi? ( >=media-libs/dssi-0.9 )
		gtk? ( >=x11-libs/gtk+-2.4
				>=dev-libs/glib-2.0
				virtual/x11
				cairo? ( >=x11-libs/cairo-0.5.0 )
		     )
		xml2? ( >=dev-libs/libxml2-2.6.8 >=dev-libs/libxslt-1.1.11 )"

DEPEND="app-arch/zip
		dev-java/jikes
		${REPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}

#	cp ${FILESDIR}/${PV}-dssi_data.h native/jni/midi-dssi/dssi_data.h \
#		|| die "Copying dssi_data.h failed."

#	epatch ${FILESDIR}/${PV}-dssi.patch
	eautoconf
}

src_compile() {
	# Note: This is written in a way to easily support GCJ and other compilers
	# at a later point. Currently Gentoo uses mainly GCJ 3.3 (from the
	# corresponding GCC) which cannot compile GNU Classpath correctly.
	# Another possibility would be ECJ (from Eclipse).
	local compiler="--with-jikes"

	econf ${compiler} \
		$(use_enable alsa) \
		$(use_enable cairo gtk-cairo) \
		$(use_enable debug ) \
		$(use_enable examples) \
		$(use_enable gtk gtk-peer) \
		$(use_enable xml2 xmlj) \
		$(use_enable dssi ) \
		--enable-jni \
		--disable-dependency-tracking \
		|| die "configure failed"
# disabled for now... see above.
#		$(use_with   doc   gjdoc) \

	emake || die "make failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS BUGS ChangeLog* HACKING NEWS README THANKYOU TODO
}

pkg_postinst() {
	if use gtk && use cairo; then
		einfo "GNU Classpath was compiled with preliminary cairo support."
		einfo "To use that functionality set the system property"
		einfo "gnu.java.awt.peer.gtk.Graphics to Graphics2D at runtime."
	fi
}
