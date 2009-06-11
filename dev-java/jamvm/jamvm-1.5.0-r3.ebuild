# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jamvm/jamvm-1.5.0-r3.ebuild,v 1.6 2009/06/11 20:48:39 maekke Exp $

EAPI=2

inherit autotools eutils flag-o-matic multilib java-vm-2

DESCRIPTION="An extremely small and specification-compliant virtual machine."
HOMEPAGE="http://jamvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug libffi"

CLASSPATH_SLOT=0.97
RDEPEND="dev-java/gnu-classpath:${CLASSPATH_SLOT}
	libffi? ( virtual/libffi )
	amd64? ( virtual/libffi )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
PDEPEND="dev-java/ant-eclipse-ecj:3.3
	dev-java/gjdoc"

src_prepare() {
	epatch "${FILESDIR}/classes-location.patch"
	eautoreconf

	# These come precompiled.
	# configure script uses detects the compiler
	# from PATH. I guess we should compile this from source.
	# Then just make sure not to hit
	# https://bugs.gentoo.org/show_bug.cgi?id=163801
	#rm -v lib/classes.zip || die
}

CLASSPATH_DIR=/opt/gnu-classpath-${CLASSPATH_SLOT}

src_configure() {
	local myconf

	filter-flags "-fomit-frame-pointer"

	if use libffi; then
		append-cflags "$(pkg-config --cflags-only-I libffi)"
	fi

	if use amd64; then
		append-cflags "$(pkg-config --cflags-only-I libffi)"
		myconf="--enable-ffi"
	fi

	# Keep libjvm.so out of /usr
	# http://bugs.gentoo.org/show_bug.cgi?id=181896
	econf \
		$(use_enable debug trace) \
		--prefix=/opt/${PN} \
		--bindir=/usr/bin \
		--datadir=/opt \
		$(use_enable libffi ffi) \
		--disable-dependency-tracking \
		--with-classpath-install-dir=${CLASSPATH_DIR} \
		${myconf}
}

create_launcher() {
	local script="${D}/opt/${PN}/bin/${1}"
	cat > "${script}" <<-EOF
#!/bin/sh
exec /usr/bin/jamvm \
	-Xbootclasspath/p:"${CLASSPATH_DIR}/share/classpath/tools.zip" \
	gnu.classpath.tools.${1}.Main "\$@"
EOF
	chmod +x "${script}"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed."

	dodoc ACKNOWLEDGEMENTS AUTHORS ChangeLog NEWS README \
		|| die "dodoc failed"

	set_java_env "${FILESDIR}/${PN}-1.5.0.env"

	local bindir=/opt/${PN}/bin
	dodir ${bindir}
	dosym /usr/bin/jamvm ${bindir}/java
	dosym /usr/bin/ecj-3.3 ${bindir}/javac
	dosym /usr/bin/gjdoc ${bindir}/javadoc
	for file in ${CLASSPATH_DIR}/bin/*; do
		base=$(basename ${file})
		create_launcher ${base#g}
	done
}
