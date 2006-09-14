# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/libgconf-java/libgconf-java-2.12.1-r1.ebuild,v 1.5 2006/09/14 20:02:20 nichoj Exp $

# Must be before the gnome.org inherit
GNOME_TARBALL_SUFFIX="gz"
inherit java-pkg eutils gnome.org

DESCRIPTION="Java bindings for Glade"
HOMEPAGE="http://java-gnome.sourceforge.net/"

# Not on gnome.org mirrors yet :-(
SRC_URI="http://research.operationaldynamics.com/linux/java-gnome/dist/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2.12"
KEYWORDS="amd64 ppc x86"
IUSE="doc gcj source"

DEPS=">=gnome-base/gconf-2.12.0
	>=dev-java/glib-java-0.2.1
	>=dev-java/libgtk-java-2.8.1
	>=dev-java/libgnome-java-2.8.0"
DEPEND=">=virtual/jdk-1.4
	${DEPS}"
RDEPEND=">=virtual/jre-1.4
	${DEPS}"
JARNAME="gconf${SLOT}.jar"

pkg_setup() {
	java-pkg_pkg_setup
	if use gcj ; then
		if ! built_with_use sys-devel/gcc gcj ; then
			ewarn
			ewarn "You must build gcc with the gcj support to build with gcj"
			ewarn
			ebeep 5
			die "No GCJ support found!"
		fi
	fi
}

src_compile() {
	# this gcj deal is a workaround for http://bugzilla.gnome.org/show_bug.cgi?id=336149
	local myflags
	use gcj || myflags="${myflags} --without-gcj-compile"
	econf ${myflags} \
		$(use_with doc javadocs) \
		--with-jardir=/usr/share/${PN}-${SLOT}/lib \
		|| die "configure failed"

	emake || die "compile failed"

	# Fix the broken pkgconfig file
	sed -i \
		-e "s:classpath.*$:classpath=\${prefix}/share/${PN}-${SLOT}/lib/${JARNAME}:" \
		${S}/gconf-java.pc
}

src_install() {
	emake DESTDIR=${D} install || die "install failed"

	# Examples as documentation
	use doc || rm -rf ${D}/usr/share/doc/${PF}/examples

	# Use the jars installed by make
	# and build our own package.env file.
	# NOTE: dojar puts the jar in the wrong place! (/usr/share/${PN}/lib)
	cat <<-END > ${D}/usr/share/${PN}-${SLOT}/package.env
DESCRIPTION=${DESCRIPTION}
CLASSPATH=/usr/share/${PN}-${SLOT}/lib/${JARNAME}
END

	use source && java-pkg_dosrc src/java/*
}
