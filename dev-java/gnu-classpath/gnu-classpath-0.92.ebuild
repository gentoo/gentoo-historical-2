# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-classpath/gnu-classpath-0.92.ebuild,v 1.2 2007/01/05 23:29:06 caster Exp $

inherit eutils multilib

MY_P=${P/gnu-/}
DESCRIPTION="Free core class libraries for use with virtual machines and compilers for the Java programming language"
SRC_URI="mirror://gnu/classpath/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/classpath"

LICENSE="GPL-2-with-linking-exception"
SLOT="0.92"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

# Add the doc use flag after the upstream build system is improved
# See their bug 24025

IUSE="alsa cairo debug dssi examples gtk xml"

RDEPEND="alsa? ( media-libs/alsa-lib )
		dssi? ( >=media-libs/dssi-0.9 )
		gtk? ( >=x11-libs/gtk+-2.4
				>=dev-libs/glib-2.0
				|| ( (
					   x11-libs/libICE
					   x11-libs/libSM
					   x11-libs/libX11
					   x11-libs/libXtst
					 )
				     virtual/x11
				   )
				cairo? ( >=x11-libs/cairo-0.5.0 )
		     )
		xml? ( >=dev-libs/libxml2-2.6.8 >=dev-libs/libxslt-1.1.11 )"

DEPEND="app-arch/zip
		dev-java/jikes
		gtk? ( || ( (
					  x11-libs/libXrender
					  x11-proto/xextproto
					  x11-proto/xproto
					)
					virtual/x11
				  )
			 )
		${REPEND}"

S=${WORKDIR}/${MY_P}

src_compile() {
	unset CLASSPATH JAVA_HOME
	# We want to force use of jikes, because it is the only way to build
	# classpath without requiring some sort of Java already available, ie ecj
	# requires a runtime and gcj already has a bundled version.
	local compiler="--with-jikes"

	# Now this detects fastjar automatically and some people have broken
	# wrappers in /usr/bin by eselect-compiler. Unfortunately
	# --without-fastjar does not seem to work.
	# http://bugs.gentoo.org/show_bug.cgi?id=135688

	# don't use econf, because it ends up putting things under /usr, which may
	# collide with other slots of classpath
	./configure ${compiler} \
		$(use_enable alsa) \
		$(use_enable cairo gtk-cairo) \
		$(use_enable debug ) \
		$(use_enable examples) \
		$(use_enable gtk gtk-peer) \
		$(use_enable xml xmlj) \
		$(use_enable dssi ) \
		--enable-jni \
		--disable-dependency-tracking \
		--prefix=/opt/${PN}-${SLOT} \
		|| die "configure failed"
	# disabled for now... see above.
	#		$(use_with   doc   gjdoc) \

	emake || die "make failed"
}

src_install() {
	emake DESTDIR=${D} install || die "einstall failed"
	dodoc AUTHORS BUGS ChangeLog* HACKING NEWS README THANKYOU TODO
}

pkg_postinst() {
	if use gtk && use cairo; then
		elog "GNU Classpath was compiled with preliminary cairo support."
		elog "To use that functionality set the system property"
		elog "gnu.java.awt.peer.gtk.Graphics to Graphics2D at runtime."
	fi
}
