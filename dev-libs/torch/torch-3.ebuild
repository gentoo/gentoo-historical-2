# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/torch/torch-3.ebuild,v 1.1 2004/06/17 17:50:29 phosphan Exp $

DESCRIPTION="machine-learning library, written in simple C++"
HOMEPAGE="http://www.torch.ch/"
SRC_URI="http://www.torch.ch/archives/Torch${PV}src.tgz
		doc? ( http://www.torch.ch/archives/Torch3doc.tgz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc debug"

DEPEND="virtual/glibc"

S=${WORKDIR}/Torch${PV}

torch_packages="convolutions datasets decoder distributions gradients kernels matrix nonparametrics speech"

src_compile() {
	local shalldebug="OPT"
	use debug && shalldebug="DBG"
	cp config/Makefile_options_Linux .
	sed -e "s:^PACKAGES.*:PACKAGES = ${torch_packages}:" \
	-e "s:^DEBUG.*:DEBUG = ${shalldebug}:" \
	-e "s:^CFLAGS_OPT_FLOAT.*:CFLAGS_OPT_FLOAT = -Wall ${CFLAGS} -ffast-math -malign-double:" \
	 -i Makefile_options_Linux

	make depend
	emake || die "emake failed"
}

src_install() {
	dolib lib/*/*.a
	dodir /usr/include/torch
	insinto /usr/include/torch
	for directory in core ${torch_packages}; do
		doins ${directory}/*.h
	done
	# prepare the options Makefile
	sed -e 's:^LIBS_DIR.*:LIBS_DIR=/usr/lib:' \
		-e 's|^INCS := .*|INCS := -I /usr/include/torch $(MYINCS)|' \
		-e '/^INCS +=/c\' -i Makefile_options_Linux
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins Makefile_options_Linux
	dodoc LICENSE
	dodir /usr/share/doc/${PF}
	insinto /usr/share/doc/${PF}
	cp -a examples ${D}/usr/share/doc/${PF}
	cd ${D}/usr/share/doc/${PF}
	sed -e 's|^TORCHDIR.*|TORCHDIR := /usr/share/torch|' \
		-e '/MAKE/c\' -e '/VERSION_KEY/c\' \
		-i examples/*/Makefile
	for ex in examples/*/Makefile; do
		echo -e '\t$(CC) $(CFLAGS_$(MODE)) $(INCS) -o $@ $< $(LIBS)' >> ${ex}
	done
	if use doc; then
		cd ${WORKDIR}/docs
		doins *.pdf
		dohtml -r manual/.
	fi
}
