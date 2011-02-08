# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libselinux/libselinux-2.0.71.ebuild,v 1.5 2011/02/08 17:13:18 arfrever Exp $

IUSE="ruby"
RUBY_OPTIONAL="yes"

inherit eutils multilib python ruby

#BUGFIX_PATCH="${FILESDIR}/libselinux-1.30.3.diff"

SEPOL_VER="2.0"

DESCRIPTION="SELinux userland library"
HOMEPAGE="http://userspace.selinuxproject.org"
SRC_URI="http://userspace.selinuxproject.org/releases/current/devel/${P}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="=sys-libs/libsepol-${SEPOL_VER}*
	dev-lang/swig
	ruby? ( dev-lang/ruby )"

RDEPEND="=sys-libs/libsepol-${SEPOL_VER}*
	ruby? ( dev-lang/ruby )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	[ ! -z "${BUGFIX_PATCH}" ] && epatch "${BUGFIX_PATCH}"

	# fix up paths for multilib
	sed -i -e "/^LIBDIR/s/lib/$(get_libdir)/" "${S}/src/Makefile" \
		|| die "Fix for multilib LIBDIR failed."
	sed -i -e "/^SHLIBDIR/s/lib/$(get_libdir)/" "${S}/src/Makefile" \
		|| die "Fix for multilib SHLIBDIR failed."
}

src_compile() {
	emake LDFLAGS="-fPIC ${LDFLAGS}" all || die
	emake PYLIBVER="python$(python_get_version)" LDFLAGS="-fPIC ${LDFLAGS}" pywrap || die

	if use ruby; then
		emake rubywrap || die
	fi

	# add compatability aliases to swig wrapper
	cat "${FILESDIR}/compat.py" >> "${S}/src/selinux.py" || die
}

src_install() {
	python_need_rebuild
	make DESTDIR="${D}" PYLIBVER="python$(python_get_version)" install install-pywrap || die

	if use ruby; then
		emake DESTDIR="${D}" install-rubywrap || die
	fi
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/selinux
}

pkg_postrm() {
	python_mod_cleanup $(python_get_sitedir)/selinux
}
