# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/nodejs/nodejs-0.7.7.ebuild,v 1.2 2012/04/04 15:32:15 mr_bones_ Exp $

EAPI=3

PYTHON_DEPEND="2"

inherit python eutils pax-utils

# omgwtf
RESTRICT="test"

DESCRIPTION="Evented IO for V8 Javascript"
HOMEPAGE="http://nodejs.org/"
SRC_URI="http://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE=""

DEPEND=">=dev-lang/v8-3.9.24.7
	dev-libs/openssl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/node-v${PV}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

#src_prepare() {
#	sed -i -e "/flags = \['-arch', arch\]/s/= .*$/= ''/" wscript || die
#}

src_configure() {
	# this is an autotools lookalike confuserator
	./configure --shared-v8 --prefix="${EPREFIX}"/usr --shared-v8-includes=${EPREFIX}/usr/include --openssl-use-sys --shared-zlib || die
}

src_compile() {
	emake || die
}

src_install() {
	# there are no words to describe the epic idiocy of ...
	# NOT using make but a JavaScript thingy to try to install things ... to the wrong place
	# WHY U NO MAEK SENSE?!
	#emake DESTDIR="${D}" install || die

	mkdir -p "${D}"/usr/include/node
	mkdir -p "${D}"/bin
	mkdir -p "${D}"/lib/node_modules/npm
	cp 'src/node.h' 'src/node_buffer.h' 'src/node_object_wrap.h' 'src/node_version.h' "${D}"/usr/include/node || die "Failed to copy stuff"
	cp 'deps/uv/include/ares.h' 'deps/uv/include/ares_version.h' "${D}"/usr/include/node || die "Failed to copy stuff"
	cp 'out/Release/node' ${D}/bin/node || die "Failed to copy stuff"
	cp -R deps/npm/* ${D}/lib/node_modules/npm || die "Failed to copy stuff"

	# now add some extra stupid just because we can
	# needs to be a symlink because of hardcoded paths ... no es bueno!
	dosym /lib/node_modules/npm/bin/npm-cli.js /bin/npm
	pax-mark -m "${ED}"/usr/bin/node
}

src_test() {
	emake test || die
}
