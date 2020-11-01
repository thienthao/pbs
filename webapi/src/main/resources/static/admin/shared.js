$(document).ready(function(e) {
    var categoryId;

    $(".modal-anchor").click(function(){
        categoryId = $(this).find("input").val();
        $("#icon-modal").modal('show');
    });

    $(".category-add-form").on("submit", function (e){
        e.preventDefault();
        var categoryName = $("#category-name").val();

        var files = $('#category-link-add').prop('files');
        var form = $(this);
        var formdata = false;
        if(window.FormData) {
            formdata = new FormData(form[0]);
        }
        formdata.set("file", files[0]);
        $.ajax({
            url: 'http://localhost:8080/api/categories/',
            data: JSON.stringify({category: categoryName}),
            cache: false,
            contentType: "application/json",
            processData: false,
            type: 'POST',
            dataType: "json",
            success: function(data, status, jqXHR) {
                $.ajax({
                    url: 'http://localhost:8080/api/categories/' + data.id + '/upload',
                    data: formdata ? formdata : form.serialize(),
                    cache: false,
                    contentType: false,
                    processData: false,
                    type: 'POST',
                    success: function(data, status, jqXHR) {
                        window.location.replace("http://localhost:8080/admin/categories");
                    }
                });
            }
        });
    });

    $(".category-icon-form").on('submit', function (){
        var files = $('#input-file-now').prop('files');

       var form = $(this);
       var formdata = false;
       if(window.FormData) {
           formdata = new FormData(form[0]);
       }
       formdata.set("file", files[0]);
       $.ajax({
           url: 'http://localhost:8080/api/categories/' + categoryId + '/upload',
           data: formdata ? formdata : form.serialize(),
           cache: false,
           contentType: false,
           processData: false,
           type: 'POST',
           success: function(data, status, jqXHR) {
           }
       });
    });

});