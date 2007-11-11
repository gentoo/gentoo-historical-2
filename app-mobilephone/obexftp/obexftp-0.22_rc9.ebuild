# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/obexftp/obexftp-0.22_rc9.ebuild,v 1.2 2007/11/11 17:37:49 mrness Exp $

inherit eutils perl-module flag-o-matic python

DESCRIPTION="File transfer over OBEX for mobile phones"
HOMEPAGE="http://dev.zuckschwerdt.org/openobex/wiki/ObexFtp"
SRC_URI="http://triq.net/obexftp/${P/_/-}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="bluetooth debug perl python ruby swig tcl"

RDEPEND=">=dev-libs/openobex-1.3
	bluetooth? ( >=net-wireless/bluez-libs-2.25 )
	perl? ( >=dev-lang/perl-5.8.8 )
	python? ( >=dev-lang/python-2.4.4 )
	ruby? ( >=dev-lang/ruby-1.8.5 )
	tcl? ( >=dev-lang/tcl-8.4.14 )"
DEPEND="${RDEPEND}
	swig? ( >=dev-lang/swig-1.3.31 )
	dev-util/pkgconfig"

S="${WORKDIR}"/${P%_*}

src_compile() {
	# do not byte-compile python module
	if use python; then
		sed -i \
			-e 's/\(setup.py install\)/\1 --no-compile/' \
			swig/python/Makefile.in || die "sed failed"
	fi

	if use debug ; then
		strip-flags
		append-flags "-g -DOBEXFTP_DEBUG=5"
	fi
	if use ruby && ! use bluetooth ; then
		sed -i -e "s/^\(.*bluetooth.*\)$/#\1/" swig/ruby/extconf.rb
	fi

	econf \
		$(use_enable bluetooth) \
		$(use_enable swig) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable tcl) \
		$(use_enable ruby) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README* THANKS TODO
	dohtml doc/*.html

	# Install examples
	insinto /usr/share/doc/${PF}/examples
	doins examples/*.c
	use perl && doins examples/*.pl
	use python && doins examples/*.py
	use ruby && doins examples/*.rb
	use tcl && doins examples/*.tcl

	use perl && fixlocalpod
}

pkg_postrm() {
	use perl && perl-module_pkg_postrm
	use python && python_mod_cleanup
}

pkg_postinst() {
	use perl && perl-module_pkg_postinst
	use python && {
		python_version
		python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
	}
}
