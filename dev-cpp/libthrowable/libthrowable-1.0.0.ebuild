# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libthrowable/libthrowable-1.0.0.ebuild,v 1.4 2007/07/10 19:22:22 beandog Exp $

inherit eutils

DESCRIPTION="Easy error handling and debugging in C++"
HOMEPAGE="http://libthrowable.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="threads examples"

DEPEND=""
RDEPEND=">=dev-util/pkgconfig-0.20"

pkg_setup() {
	# check if this is a recompile and if the USE flag threads has changed
	# must be done before anything is installed!
	if use threads; then
	   has_version dev-cpp/libthrowable && ! built_with_use dev-cpp/libthrowable threads \
		   && ewarn "You recompile with USE=threads, so remember to rebuilt all depending packages!" && epause
	else
	   has_version dev-cpp/libthrowable && built_with_use dev-cpp/libthrowable threads \
		   && ewarn "You recompile without USE=threads, so remember to rebuilt all depending packages!" && epause
	fi
}

src_compile() {
	econf $(use_enable threads pthreads) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installing ${PF} failed"
	dodoc README NEWS AUTHORS

	if use examples; then
	   insinto /usr/share/doc/${PN}/examples/
	   doins examples/*
	fi
}

pkg_postinstall() {
	elog "Please run revdep-rebuild from app-portage/gentoolkit or rebuild"
	elog "all depending packages yourself."
}
