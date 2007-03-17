# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/glib/glib-2.12.9.ebuild,v 1.8 2007/03/17 21:15:39 vapier Exp $

inherit gnome.org libtool eutils flag-o-matic

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ~ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="debug doc hardened"

RDEPEND="virtual/libc
	virtual/libiconv"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.14
	>=sys-devel/gettext-0.11
	doc? (
		>=dev-util/gtk-doc-1.4
		~app-text/docbook-xml-dtd-4.1.2
	)"


src_unpack() {

	unpack "${A}"
	cd "${S}"

	if use ppc64 && use hardened ; then
		replace-flags -O[2-3] -O1
		epatch "${FILESDIR}"/glib-2.6.3-testglib-ssp.patch
	fi

	if use ia64 ; then
		# Only apply for < 4.1
		local major=$(gcc-major-version)
		local minor=$(gcc-minor-version)
		if (( major < 4 || ( major == 4 && minor == 0 ) )); then
			epatch "${FILESDIR}/glib-2.10.3-ia64-atomic-ops.patch"
		fi
	fi
}

src_compile() {
	epunt_cxx
	elibtoolize

	local myconf

	# Building with --disable-debug highly unrecommended.  It will build glib in
	# an unusable form as it disables some commonly used API.  Please do not
	# convert this to the use_enable form, as it results in a broken build.
	# -- compnerd (3/27/06)
	use debug && myconf="--enable-debug"

	# always build static libs, see #153807
	econf \
		$(use_enable doc gtk-doc) \
		${myconf} \
		--with-threads=posix \
		--enable-static || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	# Do not install charset.alias even if generated, leave it tol libiconv
	rm -f ${D}/usr/lib/charset.alias

	# Consider invalid UTF-8 filenames as locale-specific.
	# TODO :: Eventually get rid of G_BROKEN_FILENAMES
	dodir /etc/env.d
	echo "G_BROKEN_FILENAMES=1" > ${D}/etc/env.d/50glib2
	echo "G_FILENAME_ENCODING=UTF-8" >> ${D}/etc/env.d/50glib2

	dodoc AUTHORS ChangeLog* NEWS* README
}
